%  @mainpage Othello Spieler Gruppe C
%  
%  @section Autoren
%  @li Anschuetz, Larissa.
%  @li Becker, Martin.
%  @li Helfrich, Gerhard.
%  @li Melnyk, Sergiy.
%  @li Iurii Bereshchuk.
%  
%  Das SVN Repository kann unter (https://subversion.assembla.com/svn/TeamSpace/trunk/Projekt/) aufgerufen werden.
%  
%  @section Intro
%  
%  Dies stellt ein Matlab-Projekt dar, welches einen
%  Othello/Reversi-Spieler implementiert. Dabei wird der
%  Minimax-Algorithmus, oder eine verwandte Form verwendet.
% 
%  @section Turnier-Server
%  Bereitgestellt vom LDV-Lehrstuhl der TUM als Matlab P-Code (Versionen >=
%  7.5 -> Tournier_Server_for_newer_Matlab respektive Versionen <
%  7.5 -> Tournier_Server_for_older_Matlab). Kann aufgerufen werden mit:
% @verbatim
% tournament_main('time_budget',180,'games_per_pair',2)
%@endverbatim
% 
%  @section Hauptfunktion
%  Hier gehts zum Hauptprogramm Group_C_player()


%  @brief Runs the Othello player for one round.
% 
%  More detailed description.
% 
%   @param t  time remaining in units of seconds.
%   @param color  a number indicating which disks on the board b are mine. 
%   @param b the board. each entry in this matrix with value of 'color' is assumed to be my disk. Entries with value zero are free fields, others are the opponent.
% 
%   @retval b the modified game board following the same conventions as b.
%   
function b = Group_C_player(b, color, t)

%% 
% initialise your dict_flag
persistent Dict_Flag;
if (isempty(Dict_Flag) || (abs(t - 180.) <= eps(180.)))
    % reset last_time if time is 180 seconds (new match begins).
    Dict_Flag = 1;
    disp('debug: Dict_Flag reset:');
    disp(Dict_Flag);
end
%%
% @fixme how to call functions in subfolders w/o calling addpath() every
%   time (costs time)? Not using subfolder could collide with opponent's
%   functions.
addpath([pwd '/players/Group_C_player']);

% as there is no indication from Server what is the current round number,
% delegate counting to a function
roundno = GC_getRoundNumber(t);
%% keep track of the move sequence ('F5D3...') from the game's start on
gameSequence = GC_updateMoveSequence(b, color, roundno); % this function checks what the opponent did, but also resets the sequence when a new game starts.

%% Call Time Management function: Expected return value: time in seconds,
%  which the search algorithm is allowed to spent on building the tree.

% maxDepth = GC_getMaxDepth_simple(t, roundno, Dict_Flag); %funktioniert stabil for debug
% maxDepth = GC_getMaxDepth_calctime(t, roundno, Dict_Flag);
% maxDepth = GC_getMaxDepth_lookup(t, roundno, Dict_Flag);
% maxDepth = GC_getMaxDepth_lookuptable(t, roundno, Dict_Flag);
 maxDepth  = GC_getMaxDepth_freefields(b, t, roundno, Dict_Flag);

disp([mfilename ' search depth is ' num2str(maxDepth)]);

%% OPTIONAL: check if the prediction from previous run holds true, if so
%  handover the tree of the predition to the search algorithm. Else, clear
%  the tree and handover an empty set to the search algorithm.

%% Call search algorithm.
% using callbacks here, because this way exchanging the scoring function or
% the validpositions function does not require any change in the makeMove()
% function.

if color==1
	[bewert,bester_Zug,b, dict_flag]=GC_AlphaBetaWhite(b,-Inf,Inf,maxDepth, roundno, gameSequence);
else           
	[bewert,bester_Zug,b, dict_flag]=GC_AlphaBetaBlack(b,-Inf,Inf,maxDepth, roundno, gameSequence);
end;
Dict_Flag=dict_flag;
%% OPTIONAL: save the search tree for next round.

%% actually PERFORM the chosen move.
if ~isempty(bester_Zug)
    % include my own move to move sequence, needed in next round
    gameSequence = GC_updateMoveSequence(b, color, bester_Zug)
    disp([mfilename ': choosed a move with a heuristic value=' num2str(bewert) ' at max depth=' num2str(maxDepth) '. Set disk to ' GC_coord2othseq(bester_Zug)]);
else
    disp([mfilename ': "I have to pass."']);
end;

%% display our score:
score = sum(b(:))*color;
disp('our score:');
disp(score);

%% return to Tournament Server
end
