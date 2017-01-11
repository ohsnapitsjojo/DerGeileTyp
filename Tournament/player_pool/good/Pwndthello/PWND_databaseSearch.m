function [b found] = PWND_databaseSearch(b, color, numturn)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Searches database for given board, returns flipped board with the move  
% that is most frequent in the database.                     
% Based upon www.ffothello.org/info/base.php and 
% www.ffothello.org/info/Format_WThor.pdf.
% Database includes both, moves of the opponent and own moves as double 
% digit integer number as row and column value, respectively, of 103,000 
% played games since 1977.
% The Database ist capable of providing turn information for 20 play moves, 
% which means 10 moves of our own.
% Move branches are only based on the first played stone on field position
% 5,6. If the opponent starts with first move and plays a different start
% position the function transform() provides the necesarry symmetric
% transformation of the column and row values.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%built 18/06/2012
% status: matrix dimensions error solved 21/06/2012: occures when b is
% modified more than once (not a problem of this function)
% status: switch initalMove error solved 22/06/2012: initialMove had two 
% values  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(mfilename);

% Initizalize variables
persistent database;
persistent b_old;
persistent initialMove;

% Variable for success of search
found = true;

if numturn == 1
    % Always do (5,6) move when first
    load('PWND_database.mat');
    b = PWND_makeMove(b, color, 5, 6);
    initialMove = 56;
    % Save old board for later
    b_old = b;
    return;
end

if numturn == 2
    load('PWND_database.mat');
    b_old = zeros(8);
    b_old(4,4) = 1;
    b_old(4,5) = -1;
    b_old(5,4) = -1;
    b_old(5,5) = 1;
    
    % Find opponents move
    [mopp,nopp] = find(~b_old-~b);
    % Identify start position
    initialMove = indices2num(mopp, nopp);
end
if isempty(database)
    found = false;
    disp('database exceeded');
    return;
end
% Find opponents move
[mopp,nopp] = find(~b_old-~b);
[mopp,nopp] = convert(mopp, nopp, initialMove);
% Reduce database according to opponents move in column numturn-1
database = database(database(:,numturn-1) == indices2num(mopp,nopp),:);
% Save all possibilities for next move
datacol = database(:,numturn);
if isempty(datacol)
    disp('No move was found in database');
    found = false;
    return;
end
% Find most frequent move as most likely best move
bestmove = mode(double(datacol));
% Reduce database according to own best move in current column
database = database(database(:,numturn) == bestmove,:);
% Convert best move into indices format for given startposition
[m,n] = num2indices(bestmove);
[m,n] = convert(m, n, initialMove);
disp(['Size of database: ' num2str(size(database))]);
% disp(['Database move: ' num2str(m) 'x' num2str(n)]);
% Make move and update b_old
b = PWND_makeMove(b, color, m, n);
b_old = b;
disp('Database Move');

%% Converts database format into [m,n] indices
function [m, n] = num2indices(num)
m = floor(double(num)/10);
n = rem(num,10);

%% Converts [m,n] indices into database format
function num = indices2num(m, n)
num = m*10 + n;

%% Convert indices into database format depending on startposition
function [mnew, nnew] = convert(m, n, initialMove)

switch initialMove
    case 56
        mnew = m;
        nnew = n;
    case 65
        mnew = n;
        nnew = m;
    case 43
        mnew = 9-m;
        nnew = 9-n;
    case 34
        mnew = 9-n;
        nnew = 9-m;
end