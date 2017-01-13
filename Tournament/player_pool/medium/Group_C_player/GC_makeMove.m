% @brief Makes the best possible move in this round.
% 
% This function decides what the best moves are and returns 
% 
% @author Larissa Anschuetz
% @date 2011-Jan-14
% 
% @param b the game board coded as a matrix. 
% @param color all fields in b having value given in color are considered
%     to be my disks. Fields with zero are considered to be empty. All other
%     fields are interpreted as 'occupied by the opponent'.
% @param depth search depth of the search algorithm. Value to be found
%     out, maybe 3, 4 or 5, or higher in the end-game?
% @param t time left in this game in units of seconds.
% @param roundno an integer value indicating the current round number,
%     starting at one, must not be negative.
% @param func_getValidPositions a function pointer to a function, which can
%     return a set of possible boards one round in the future.This function
%     must satisfy the following convention: (@f)( board , color, round_no).
%     The arguments are explaned in detail in the function GC_getValidPositions.m
% @param func_scoreBoard a function pointer to a function, taking a board snapshot and
%     returning a numerical value indicating "how good" this board snapshot is. INTERFACE TBD.
% @param treeCache (optional) if set, the function relies that the given
%     tree is valid already and spends its time expanding the tree and choosing
%     the best move on the expanded tree. Validity check must be performed by
%     the caller. If the predicted tree is not valid, it can be set to empty
%     and the function will generate a new tree.
% @param gameSequence an alphanumeric sequence indicating the othello moves
%     done up to now. This is required by the GC_getValidPositions() function.
% @param alpha is the minimum result of Group_C_player
% @param beta is the maximum result of the opponend
% @retval bestpos returns one m-by-n matrix describing how the board looks like after the chosen move.
%     Has the same dimension as input argument b.
% @retval diskSet is a 2-by-1 vector holding a 2D coordinate [r,c] with 1<=r,c<=8 describing
%     which disk was set to get to the board bestpos.
% @retval best scalar value yielding an evaluation of the board with a
%     recursion depth of given by argument depth. Needed for recursive calls.
%     An external caller can ignore that return value.
% 
function [bestpos, best, diskSet] = GC_makeMove(board, color, round_no, depth, gameSequence, alpha, beta)
best = -Inf;
bestpos = board;

% break condition: searchdepth -> rating
  if (depth <= 0)
    [ possibleBoards, disksNew, numDisksRev ] = GC_getValidPositions(board, color, round_no, gameSequence);
    tryM = GC_getBoardEval(possibleBoards, color); % scoreBoard returns heuristic maximum value
    best = color * sum(sum(tryM .* possibleBoards)); % scalar value
    % bestpos =?
    diskSet = bestpos - board; % hier braeuchte ich das board, welches score board benutzt? 
    [r, c] = find(diskSet);
    diskSet = [r, c];
    return; 
  end 
 % break condition: no moves are possible -> rating
  [ possibleBoards, disksNew, numDisksRev ] = GC_getValidPositions(board, color, round_no, gameSequence); 
  if (isempty(possibleBoards(:,:,:)))  %true if no moves are possible
    tryM = GC_getBoardEval(b, color); % scoreBoard return heuristic maximum value
    best = color * sum(sum(tryM .* board)); 
    diskSet = 0;
    return; 
  end
  
 numBoards = size(possibleBoards,3); % 3rd dim. determines the number of possible moves
 
 % Instead of identifying alternating the maximum and minimum (minimax algorithm)
 % rating is negated and the maximum value identified. The own move is
 % rated positive, the opponend move is rated negative (negamax algorithm).
  for j = 1:numBoards     % number of possible moves
    v = possibleBoards(:,:,j);    
    rating = -(GC_makeMove(v, -color, round_no+1, depth - 1, gameSequence, -beta, -alpha));
    % alpha-beta pruning
    if (rating>=beta)
        best = beta;
        diskSet = bestpos - v;
      [r, c] = find(diskSet);
      diskSet = [r, c];
       return  % beta-cutoff
    end
    if (rating>alpha)
        best = alpha;
        diskSet = bestpos - v;
      [r, c] = find(diskSet);
      diskSet = [r, c];
        return
    end
    if (rating > best) %redundant, ist alpha == best??
      best = rating;
      bestpos = v;
      % retval diskSet
      diskSet = bestpos - v;
      [r, c] = find(diskSet);
      diskSet = [r, c];
    end
  end
end
     
