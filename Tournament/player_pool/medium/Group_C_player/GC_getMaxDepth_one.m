% @brief Time Management. Based on current time elapsed and probably on
% round number, the function returns a time which may be used at maximum in
% the current turn.
% 
% @author Martin Becker
% @date 2011-Jan-16
% 
%   @param t_game  time remaining in this game. Scalar double-type argument
%   in units of seconds.
%   @param round_no a nonzero, positive number indicating what the
%   current round number is. Note that it needs the number of MY turns, not
%   the number of opponents.
%  
%  @retval MaxDepth, is the search depth for a search algorithm tree.
%   It indicates how much the player is allowed to "search" in his current subtree.
% 
function [ MaxDepth ] = GC_getMaxDepth_one(t_game, round_no)


MaxDepth=1;

end