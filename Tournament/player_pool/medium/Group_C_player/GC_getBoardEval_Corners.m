% @brief Heuristic evualuation function. Judges for a given board, whereas I am
% coded with 'color', if the situation is good for me. Here it prefers
% occupying the corners and having a maximal number of disks.
% 
% @author Martin Becker
% @date 2011-Jan-24
% 
% @param board the playing board described by an 8-by-8 matrix.
% @param color - positions in 'board' where the value equals 'color' are
%     assumed
%     to be my disks. Elements with zero are assumed to be free, whereas
%     others are all opponents.
% @retval eval a scalar double-type value indicating how 'good' the given
%     constellation is for me. Higher values are better.
function [eval] = GC_getBoardEval_Corners(board, color)      

mine = (board == color);
opp  = (board ==-color);

%%  EDGES
    M = [15, -5,  1,  1,  1,  1, -5, 15; ...
         -5,-10,  1,  1,  1,  1,-10, -5; ...
          1,  1,  1,  1,  1,  1,  1,  1; ...
          1,  1,  1,  1,  1,  1,  1,  1; ... 
          1,  1,  1,  1,  1,  1,  1,  1; ...
          1,  1,  1,  1,  1,  1,  1,  1; ...
         -5,-10,  1,  1,  1,  1,-10, -5; ... 
         15, -5,  1,  1,  1,  1, -5, 15];
     
    corner_score = (M.*mine) - (M.*opp) ;       
    corner_score = sum(corner_score(:));

%% NUMBER OF DISKS I HAVE MORE THAN OPPONENT    
    disk_excess = sum(mine(:)) - sum(opp(:));    
    eval = corner_score + disk_excess;
end