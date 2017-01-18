% @brief Time Management. Based on current time elapsed and probably on
% round number, the function returns a time which may be used at maximum in
% the current turn.
%
% @author Gerhard Helfrich
% @date 2010-Dec-21
%
%   @param t_game  time remaining in this game. Scalar double-type argument
%   in units of seconds. We want to save this value in a persitent variable
%   to messure the time our algortihm needs to perform a move in the last
%   round
%
%   @param round_no a nonzero, positive number indicating what the
%   current round number is. Note that it needs the number of MY turns, not
%   the number of opponents.
%
%   @retval MaxDepth, is the search depth for a search algorithm tree.
%   It indicates how much the player is allowed to "search" in his current subtree.
%
function [ MaxDepth ] = GC_getMaxDepth_lookup(t_game, round_no, dict_flag)

%measuring for lookuptable

persistent last_time;


%initialse variable last_time
if (isempty(last_time) || (abs(t_game - 180.) <= eps(180.)))
    % reset last_time if time is 180 seconds (new match begins).
    last_time = double(180)*ones(61,1);
    disp('debug: last_time reset:');
    %disp(last_time);
    
else
    % just happy update
    last_time(round_no+1) = t_game;
    % disp('debug: las_time:');
    %disp(last_time);
    
end


%calculate the time your player needs for one move / round
if(round_no==1)
    time_diff = 0.001;
else
    time_diff = last_time(round_no)-t_game;
end
disp('debug: round_no');
disp(round_no);
%disp('debug: last_time(round_no):');
%disp(last_time(round_no));
disp('debug: time_diff:');
disp(time_diff);

%set MaxDepth
if (round_no <= 7)
    MaxDepth = 1;
else if(round_no > 7)
        MaxDepth = ceil((round_no -7));
    end
end

disp('Debug: MaxDepth:');
disp(MaxDepth);

end