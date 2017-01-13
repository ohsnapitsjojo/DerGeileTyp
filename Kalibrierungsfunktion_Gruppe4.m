function Kalibrierungsfunktion_Gruppe4()
% This is a benchmark function
%
% The output is a txt file named
% 'Kalibrierungsfunktion_Gruppe4_log_yyyymmdd_HHMMSS.txt', where
% yyyymmdd_HHMMSS is the timestamp
%
% The first line of the log file contains the values from Matlab's own
% benchmark with command 'bench'
% All other lines contain times for 14 different calculations. Check code
% below for detailed information about each value.
%
% Execute the following code to import bench data from log:
%    filename = 'Kalibrierungsfunktion_Gruppe4_log_yyyymmdd_HHMMSS.txt';
%    startRow = 4;
%    formatSpec = '%12f%12f%12f%12f%12f%12f%12f%12f%12f%12f%12f%12f%12f%f%[^\n\r]';
%    fileID = fopen(filename,'r');
%    dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
%    fclose(fileID);
%    benchData = [dataArray{1:end-1}];
%    clearvars filename startRow formatSpec fileID dataArray ans;



%% init log file
% set filename to write to
currentFullFilename = which('Kalibrierungsfunktion_Gruppe4.m');
[pathStr,~,~] = fileparts(currentFullFilename);
filename = [pathStr '\Kalibrierungsfunktion_Gruppe4_log_' datestr(now,'yyyymmdd_HHMMSS') '.txt'];
% create/open txt-file
fid = fopen(filename, 'wt');

%% define parameters
% define various fields
b1 = [0     0     0     0     0     0     0     0 ;...
      0     0     0     0     0     0     0     0 ;...
      0     0     0     0     0     0     0     0 ;...
      0     0     0     1    -1     0     0     0 ;...
      0     0     0    -1     1     0     0     0 ;...
      0     0     0     0     0     0     0     0 ;...
      0     0     0     0     0     0     0     0 ;...
      0     0     0     0     0     0     0     0 ];

b2 = [0     0     0    -1     0     0     0     0 ;...
      0     0     0    -1    -1    -1     0     0 ;...
      0     0    -1    -1    -1    -1    -1    -1 ;...
      0     0    -1    -1    -1     1     1    -1 ;...
      0     0    -1    -1     1    -1    -1     0 ;...
      0    -1    -1    -1    -1    -1    -1     0 ;...
      0     0     0     0     0     0     0     0 ;...
      0     0     0     0     0     0     0     0 ];

  
b3 = [-1   -1    -1    -1    -1    -1     0     0 ;...
      0    -1    -1    -1    -1    -1     0     0 ;...
      0     1     1     1    -1     1     0     1 ;...
      0     1     1    -1    -1     1     1     1 ;...
      0     1     1     1     1     1     1     1 ;...
      0     0     0     0     1     1     1     0 ;...
      0     0     0     0     1     1     0     0 ;...
      0     0     0     0     1     0     0     0 ];

b4 = [0     0     1     1     1     0     1     0 ;...
      0     1     1     1     0     1     0     0 ;...
      1     1     1    -1     1    -1     1     0 ;...
      1     1    -1     1    -1    -1     0     0 ;...
      1    -1     1     1     1    -1     0     0 ;...
     -1     1     0     0     0    -1     1     0 ;...
      0     1     0     0     0    -1     1     0 ;...
      0     0     0     0     0     0     0     0 ];

b5 = [0     0     0     0    -1     0     0     0 ;...
      0     0     0     0    -1    -1     0     0 ;...
      1    -1     0     0    -1    -1     0     0 ;...
      0     1     1     1    -1    -1     0     0 ;...
      1     1     1    -1     1     0    -1     0 ;...
      0    -1     0     1    -1     0     0     0 ;...
      0     0     0     0     0     0     0     0 ;...
      0     0     0     0     0     0     0     0 ];

b6 =[ 0     0     0     0     0     0     0     0 ;...
      0     0     0     0     0     0     0     0 ;...
      0     0     0     0     0     0     0     0 ;...
      0     0    -1    -1    -1     0     0     0 ;...
      0     0     0    -1     1     0     0     0 ;...
      0     0     0     0     0     0     0     0 ;...
      0     0     0     0     0     1     0     0 ;...
      0     0     0     0     0     0     0     0 ];
  
b7 = [0     0     0     0     0     0     0     0 ;...
      0     0     0     0     0    -1     0     0 ;...
      0     0     0     0    -1    -1     0     0 ;...
      0     0    -1    -1    -1    -1     0     0 ;...
      0     0     0     1    -1    -1     0     0 ;...
      0     0     1     0    -1    -1     0     0 ;...
      0     0     0     0     0     0     0     0 ;...
      0     0     0     0     0     0     0     0 ];

b8 = [0     0     1     1     1     1     1     1 ;...
      0     0    -1    -1    -1    -1     1     1 ;...
      0     0    -1    -1     1     1     1     1 ;...
      0     0    -1    -1     1     1    -1     1 ;...
      0     0    -1    -1     1    -1    -1     1 ;...
      0    -1    -1    -1    -1    -1    -1     1 ;...
      0     0     0     0     0     0     0     0 ;...
      0     0     0     0     0     0     0     0 ];
 
%% start calibration  

% default bench
b = bench;
fprintf(fid, ['Matlab Bench:\n' num2str(b) '\n']); 

% custom bench
fprintf(fid, 'Custom Bench:\n'); 
lines = 0;
while lines < 10000
    
    % do calculations
    b = zeros(1,14);
    % all possible moves
    t = tic; for rep = 1:10; allPossible(b1,  1); end; b(1) = toc(t);
    t = tic; for rep = 1:10; allPossible(b1, -1); end; b(2) = toc(t);
    t = tic; for rep = 1:10; allPossible(b2,  1); end; b(3) = toc(t);
    t = tic; for rep = 1:10; allPossible(b2, -1); end; b(4) = toc(t);
    t = tic; for rep = 1:10; allPossible(b3,  1); end; b(5) = toc(t);
    t = tic; for rep = 1:10; allPossible(b3, -1); end; b(6) = toc(t);
    t = tic; for rep = 1:10; allPossible(b4,  1); end; b(7) = toc(t);
    t = tic; for rep = 1:10; allPossible(b4, -1); end; b(8) = toc(t);
    t = tic; for rep = 1:10; allPossible(b5,  1); end; b(9) = toc(t);
    t = tic; for rep = 1:10; allPossible(b5, -1); end; b(10) = toc(t);
    t = tic; for rep = 1:10; allPossible(b6,  1); end; b(11) = toc(t);
    t = tic; for rep = 1:10; allPossible(b6, -1); end; b(12) = toc(t);
    % matrix multiplikation
    t = tic; for rep = 1:100; b1*b2*b3*b4*b5*b6*b7*b8; end; b(13) = toc(t);
    % call recursive function
    t = tic; recursive_test(0, 100); b(14) = toc(t);
    
    
    % write to file
    fprintf(fid, [num2str(b) '\n']); 
    lines = lines + 1;

end

% close log file
fclose(fid);
% close all windows (from bench command)
close all;

end



function out = recursive_test(currDepth, maxDepth)

    currDepth = currDepth + 1;
    
    % do some calculations
    out = sqrt(magic(5));
    
    % go deeper
    if currDepth < maxDepth
        out = out * recursive_test(currDepth, maxDepth);
    end
    
    % do more calculations
    out = out + 1;
    
end



function possible = allPossible( b, color )
    % Gibt eine Liste zurück mit allen Feldern auf die ein Möglicher Zug
    % erfolgen kann
    % Drei Bedinungen sind dazu notwendig: 
    % -Feld ist frei,
    % -Feld grenzt an gegn. Stein
    % -Stein dreht Steine um
    % profile on; profile clear;

    mapIdx = 1:64;

    % Matrix mit freien Felder
    % Matrix mit Feldern, angrenzend an gegn. Steinen

    adjacencyList = mapIdx((conv2(double(b==-color), ones(3), 'same')~= 0) == (b==0));
    flag=checkFlip(b,color,adjacencyList);
    possible=adjacencyList(flag);
    % profile report;
end

function [flag] = checkFlip(b, color, adjacencyList )
% Diese Funktion Überprüft ob beim setzene eines Steins auf move ein
% gegnerischer Stein geflippt wird

    directions = {[0,-1] [1,1] [0,1] [1,-1] [-1,0] [-1,-1] [1, 0] [-1,1]};  % Mögliche 8 Richtungen
    len = length(adjacencyList);
    flag = false(1,len);
    for id = 1:len
        for idx = 1:8
            if checkFlipDirection(b,color,adjacencyList(id),directions{idx}) % Alle Richtungen werden ausprobiert
                flag(id) = true;
                break;
            end
        end
    end
end

function [flag] = checkFlipDirection(b,color,move,direction)
% Gibt zurück ob sich nach dem Setzten eines Streines an position move
% mindestens ein gegnerischer Strein Flipt beim verfolgen der Richtung
% direction
    flag = false;
    opponentFound = false;  % Bezeichnet das finden eines Gegnerischen steines in der untersuchten linie
    opponent = -1*color;
    %% Berechnung ohne Funktionaufruf über idx2xy ca 33% schneller
    x = ceil(move/8);
    y = mod(move,8);
    if(y==0)
        y = 8;
    end
    %%
    while 0<x && x<9 && 0<y && y<9 
        x = x + direction(1);
        y = y + direction(2);
        
        if x<1 || y<1 || 8<x || 8<y         % Failsafe für Indexfehler
            break;
        end
        
        if b(y,x) == 0                      % Es gibt keine druchgehende Verbindung von Streinen
            flag = false;
            break;
        end

        if b(y,x) == opponent && ~opponentFound     % Finde gegnerischen Stein im Pfad
            opponentFound = true;
        end
        if b(y,x) == color && ~opponentFound        % Es gibt keinen gültigen pfad und es werden keine Steine geflippt 
            flag = false;
            break;
        end
        if b(y,x) == color && opponentFound         % Finde eigenen Stein nach einem gegnerischen im Pfad
            flag = true;
            break;    
        end
    end 
end