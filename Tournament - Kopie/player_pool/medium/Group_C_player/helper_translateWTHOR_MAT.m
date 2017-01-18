% @file helper_translateWTHOR_MAT.m
% @brief converts WTHOR format to something which can be processed faster.
% Save as MAT-file
% @author Martin Becker
% @date 2011-Jan-14
clc;
clear all;
close all;

%% #### SETTINGS ####
srcFileName = 'Logistello_book_1999.wtb';  % WTHOR WTB-Format

%% #### DO NOT TOUCH ANYTHING FROM HERE ON ####

fid_src = fopen(srcFileName , 'rb');

if (fid_src <= 0)
    error('WTHOR file not found!');
    return;
end


%% consume header

header = fread(fid_src, 16);

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
    fclose(fid_src);
    return;
end

%% FILE INREGRITY CHECK: check file size.
expectedFileSize = 16 + numFields*68;
pos = ftell(fid_src);
fseek(fid_src, 0, 'eof');
endpos = ftell(fid_src);
if endpos ~= expectedFileSize
    error(['File size wrong: ' num2str(endpos) ' instead of expected ' num2str(expectedFileSize) ' bytes.']);
    fclose(fid_src);
    return
end
% restore position
fseek(fid_src,pos,'bof');

disp('### MOVES');
maxNum = 10;%numFields;
minNum = 1;

%% read numEl entrys at once.

done = 0;
processed = 0;

moveList = cell(numFields, 4);

hw=waitbar(0,'building list...');

% 68 bytes per entry.
for k = 1:numFields
    waitbar(k/numFields);
    thisMove = fread(fid_src, 68);

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

    % write to file on plan text format (faster processing)
    
    moveList{k,1} = numPlayersBlack;
    moveList{k,2} = numPlayersWhite;
    moveList{k,3} = score_fin_black;
    moveList{k,4} = seq;
end    
close(hw);

fclose(fid_src);

save ([srcFileName '.mat'], 'moveList');