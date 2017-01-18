%  @brief (1) This function should be called immediately after the opponent set
%  his disk, in order to save the move and concat it to the move sequence
%  list.
%  (2)This function must also be called whenever I have set a disk, in order
%  to also include it to the list.
%  
%  Consequently there are two different call possibilities:
%       gameSequence = GC_updateMoveSequence(b, color, roundno);  % for case (1)
%       []           = GC_updateMoveSequence(b, color, diskSet);  % for case (2)
% 
%  @author Martin Becker
%  @date 2011-Jan-18
% 
%  @callgraph
%  @callergraph
% 
% input arguments
%   @param board the playing board described by an m-by-n matrix.
%   @param color positions in 'board' where the value equals 'color' are assumed
%      to be my disks. Elements with zero are assumed to be free, whereas
%      others are all opponents.     
%   @param round_no - the number of the current round. Used to decide
%   whether special opening dictionary moves are incorporated. 
% 
% return value:
%   @retval sequence an alphanumeric sequence indicating the othello
%   moves (incl. opponent's moves) done in this game up to now.
function [sequence] = GC_updateMoveSequence(board, color, arg3)

persistent gameSequence;    % game history
persistent oppPossBoards;   % set of possible board the opponent can play in next ply
persistent oppDisksNew  ;   % set of set disks belonging to oppPossBoards


if (numel(arg3) == 2)   % given a 2D coord
%%   case (2): update sequence with my own move given as arg3. Also predict future moves for opponent.
    % just add my move to the list.
    gameSequence = cat(2,gameSequence, GC_coord2othseq(arg3));
   
    %disp([mfilename ': "I set a disk to '  char(arg3(2,1)+96) num2str(arg3(1,1)) '"']);
    
    % predict what the opponent could do now and save this in persistent
    % variables. Later, when the opponent did his move, we use this predictions to check WHAT
    % he actually did.
    [oppPossBoards, oppDisksNew] = GC_getValidPositions( board , -color, 2, '');    % empty sequence prevents dictionary to be used
   
    sequence = gameSequence;
elseif (numel(arg3)==1) 
%%  case (1): Update sequence with what the opponent did.
    % compare the predictions in oppPossBoards with the current board, to
    % spot the move he did.
        
    % special case: first call in this game. check who begins
    if (arg3 == 1) % new game starts -> No predictions.   

        gameSequence = [];  % empty the move list
        oppPossBoards = [];
        oppDisksNew = [];
        
        % check whether I or the opponent is the opener (=black). Assumption:
        % black is coded to -1.
        initBoard = zeros(8);    
        initBoard(4:5,4:5) = [ 1 , -1;   
                              -1 ,  1];
        if (isequal(board, initBoard))
            disp([mfilename ': "I will be starting the game."']);        
            % nothing we can do right now. sequence stays empty as the
            % opponent didn't do anything, yet.
            sequence = gameSequence;
            return;
        else
            % THE OPPONENT ALREADY SET A STONE -> CHECK WHICH ONE.
                        
            % remove center four.
            bFilt = board;
            bFilt(4:5,4:5)=0;   % wipe out the central four

            idx = find(bFilt, 1);  % get the coordinate of the one disk which was set.

            switch idx
                %%IF WHITE BEGINS
                case 21
                    startingPosition = 'c5';
                case 30
                    startingPosition = 'd6';
                case 35
                    startingPosition = 'e3';
                case 44
                    startingPosition = 'f4';
                    
                % IF BLACK BEGINS
                case 45
                    startingPosition = 'f5';
                case 20
                    startingPosition = 'c4';
                case 27
                    startingPosition = 'd3';
                case 38
                    startingPosition = 'e6';
                otherwise
                    warning([mfilename ': somehow the first disk set by opponent is at an invalid position: ind=' num2str(idx) ]);
                    startingPosition = '';
            end

            disp([mfilename ': "Opponent started with ' startingPosition '."']);
            
            % save opponent's move.
            gameSequence = cat(2,gameSequence, startingPosition);
            sequence = gameSequence;
        end % isequal
        
    elseif (isempty(oppPossBoards))
        % roundNumber > 1, but no prediction. The opponent had to PASS.
        % nothing we can do, as the opponent didn't do a thing.
        disp([mfilename ': "Opponent had to pass."']);
        sequence = gameSequence;
        return;
    else    % RoundNumber > 1 and prediction available
        % check which move was done and save the disk to the move list.
        %disp([mfilename ': "Opponent set a disk..determining which one..."']);        
        numBoards = size(oppDisksNew,2);
        %disp([mfilename ': "Opponent had ' num2str(numBoards), ' possibilities."']);        
        found = 0;
        for k = 1:numBoards
            if isequal(oppPossBoards(:,:,k), board)
                %disp([mfilename ': "Opponent set disk to '  char(oppDisksNew(2,k)+96) num2str(oppDisksNew(1,k)) '"']);
                gameSequence = cat(2,gameSequence, GC_coord2othseq(oppDisksNew(:,k)));
                found = 1;
                sequence = gameSequence;
                break;  % don't waste time.
            end
        end
        if ~found
            % ugh! something went wrong. Opponent did a move the prediction
            % didn't offer. Discard the whole sequence.
            gameSequence = [];
            sequence = gameSequence;
            warning([mfilename ': "Something went wrong. I didn''t see that move possibility for opponent. Lost sequence."']);
        end
    end % RoundNumber == 1
else
    % can occur when no move is possible and hence diskSet (given as 3rd
    % arg) is empty.
    %warning([mfilename ': "Wrong calling convention for 3rd argument used. Check parameters."']);
    sequence = ''; 
end


