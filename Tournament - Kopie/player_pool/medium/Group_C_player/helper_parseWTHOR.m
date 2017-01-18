% @file helper_parseWTHOR.m
% @brief trying to read out WTHOR format
% @author Martin Becker
% @date 2011-Jan-14
clc;
clear all;
close all;

fid = fopen('Logistello_book_1999.wtb' , 'rb');

if (fid <= 0)
    error('WTHOR file not found!');
    return;
end

%% consume header

header = fread(fid, 16);

year = header(1) * 100 + header(2);
month = header(3);
day = header(4);

% little endian
numFields = header(5) + bitshift(header(6),8) + bitshift(header(7),16) + bitshift(header(8),24); % number of entrys in file
numNames = header(9) + bitshift(header(10),8);                                                   % must be zero

fieldsize = header(13);                      %% funny...somehow this is wrong.
if (fieldsize == 0), fieldsize = 8; end;

gametype = header(14);

searchDepth = header(15);
if (year >= 2001) & (searchDepth==0)
    searchDepth = 22;    
end

% show header info
disp(['WTHOR INFO: Date=' num2str(year) '-' num2str(month) '-' num2str(day) '; number of games=' num2str(numFields) '; number of Names=' num2str(numNames) ', field size=' num2str(fieldsize) ', search depth=' num2str(searchDepth) '.']);

%% SANITY CHECK:
if (numFields == 0 || numNames > 0 || fieldsize ~= 8)
    error('Wrong WTHOR file. Must be a game file (*.wtb) for 8x8 boards!');
    fclose(fid);
    return;
end

%% FILE INREGRITY CHECK: check file size.
expectedFileSize = 16 + numFields*68;
pos = ftell(fid);
fseek(fid, 0, 'eof');
endpos = ftell(fid);
if endpos ~= expectedFileSize
    error(['File size wrong: ' num2str(endpos) ' instead of expected ' num2str(expectedFileSize) ' bytes.']);
    fclose(fid);
    return
end
% restore position
fseek(fid,pos,'bof');

disp('### MOVES');
maxNum = 10;%numFields;
minNum = 1;

%% read numEl entrys at once.

tic
maxEl = 100000;
    
done = 0;
processed = 0;

thisSeq = 'f5d6c4g5c6c5d7d3b4c3e3';

matchList = [];
numMatches = 0;
maxNumMatches = 1000;

while (~done)
    
    
    if maxEl > (numFields-processed)
        chunkEl = numFields-processed;
    else
        chunkEl = maxEl;
    end
    
    moveList = cell(chunkEl,4);

    % 68 bytes per entry.
    for k = 1:chunkEl
        thisMove = fread(fid, 68);

        %f1 = thisMove(1) + bitshift(thisMove(2),8);
        numPlayersBlack = thisMove(3) + bitshift(thisMove(4),8);
        numPlayersWhite = thisMove(5) + bitshift(thisMove(6),8);

        score_cur_black = thisMove(7);
        score_fin_black = thisMove(8); % <32 = black lost game, 32=tie, >32 = black won game.

        % 9...68 = sequence. Black always begins. F5 is always the first move.
        seq = [];
        for s = 1:60
            row = char(floor(thisMove(8+s)/10)+48);
            col = char(mod(thisMove(8+s),10)+96);
            seq = cat(2,seq,[col row]); 
        end

        moveList{k,1} = numPlayersBlack;
        moveList{k,2} = numPlayersWhite;
        moveList{k,3} = score_fin_black;
        moveList{k,4} = seq;
        %disp(['f1=' num2str(f1) ', numPlayersBlack=' num2str(numPlayersBlack) ', numPlayersWhite=' num2str(numPlayersWhite) ', current score=' num2str(score_cur_black) ', final score=' num2str(score_fin_black) ', sequence=' seq '.']);
    end
    
    %% try to find something in this chunk
    IDXs = not(cellfun(@isempty, regexp(moveList(:,4),['^' thisSeq '.*'])));
    numChunkMatches = sum(IDXs);
    
    % do not exceed a max number of matches (stability and so on...)
    if (numChunkMatches > (maxNumMatches-numMatches))
        IDXs = find(IDXs == 1, maxNumMatches-numMatches);
        numMatches = maxNumMatches; % full
        done = 1;       % abort search
        break;
    else
        numMatches = numMatches + numChunkMatches;        
    end
    matchList = cat(1,matchList, moveList(IDXs,:)); % put to match list
       
    if maxEl > chunkEl, done=1; end;    % end of data reached
    processed = processed + chunkEl;
    
end
t_read = toc

disp(['Got ' num2str(numMatches) ' matching games.']);

fclose(fid);