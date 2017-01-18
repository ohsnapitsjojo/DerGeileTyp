function [depth, msg] = PWND_determineDepth(numturn, time_left)
% This function determines the search depth for the negamax function of the
% main player taking into account the gamestate.
% In the beginning of the game, the search depth is fixed depending on the
% move number with a minumum search depth of 4.
% In the midgame, it is estimated if the search depth can be increased by 1
% and if this depth could be used until the end of the game (including a
% time margin). Otherwise the depth of the last search is kept. In the
% endgame, it is tried to calculate until the end of the game in order to
% profit from the modified evaluation function. As a fallback, the search
% depth is decreased if we're running out of time.
% numturn ranges between 1 and 60 (odd for black, even for white)

persistent last_depth;
persistent last_time_left;

if time_left < 5
    % last stand, quickly go back
    msg = 'spent too much time before, hurry up!';
    depth = 1;
    return;
end

%% Endgame if time budget is big enough
if numturn >= 50 && time_left > 40
    msg = 'endgame';
    % fair amount of time left, use maximum depth until end
    depth = 61 - numturn;
    return;
end

%% Determine the depth for beginning and midgame
if numturn < 35
    msg = 'beginning';
    depth = 5;
    if numturn < 23
        depth = 4;
    end
else
    % Midgame: increase search depth if we estimate we can keep the
    % increased search depth until the end
    
    [factor, msg] = updateValues(numturn);
    
    % Estimate move time and time budget for depth = last_depth +1
    time_lastMove = last_time_left - time_left;
    timeMoveDepthInc = time_lastMove * factor;
    timeBudgetDepthInc = time_left - timeMoveDepthInc;
    
    movesUntilEnd = ceil((60-numturn+1)/2);
    timeBudgetEnd = time_left - (timeMoveDepthInc * movesUntilEnd);
    
    disp(['Estimating with branching factor ' num2str(factor) ' for increased depth ' num2str(last_depth+1) ':']);
    disp(['Estimated time budget at next move: ' num2str(timeBudgetDepthInc) 's']);
    disp(['Estimated time budget at end of game: ' num2str(timeBudgetEnd) 's']);
    
    if timeBudgetEnd > 30
        depth = last_depth + 1;
        msg = [msg ' (inc.)'];
    else
        depth = last_depth;
        msg = [msg ' (same)'];
    end
end

%% Overwrite depth if running out of time
if time_left < 30
    msg = 'low time budget';
    depth = 5;
    if time_left < 20
        depth = 4;
        if time_left < 15
            depth = 3;
            if time_left < 10
                depth = 2;
            end
        end
    end
end

%% Save variables
last_depth = depth;
last_time_left = time_left;

end

function [factor, msg] = updateValues(numturn)
% Assume rather pessimistic values of the time factor for increased search
% depth. Further assume less possibilites towards the end of the game.
msg = 'midgame';
if numturn < 47
    factor = 3;
    if numturn < 45;
        factor = 4;
        if numturn < 43
            factor = 5;
        end
    end
else
    factor = 3;
end
end