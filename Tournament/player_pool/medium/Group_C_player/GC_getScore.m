%  @brief Given a snapshot of a game board, this function returns the
%  current score of the board.
% 
%  @author Martin Becker
%  @date 2011-Jan-28
% 
%  @callgraph
%  @callergraph
% 
% input arguments
%   @param board the playing board described by an m-by-n matrix.
%   @param color - positions in 'board' where the value equals 'color' are
%       assumed
%       to be my disks. Elements with zero are assumed to be free, whereas
%       others are all opponents. 
% return value:
%   @retval myScore a integer value in the range [0,60] representing the
%       score of the player with 'color'.
function [ myScore ] = GC_getScore( board , color)

myScore = sum(sum(board == color));