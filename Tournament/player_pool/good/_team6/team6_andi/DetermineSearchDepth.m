function [ depth ] = DetermineSearchDepth(time_left)

% function provides different values for search depth according to the
% following variables: number_of_turns, time_left
% the game is classified in three parts; at the end there's a security
% check, so that we can finish the game without being disqualified;
% the chosen values were tested several times and led to optimal results 
% in final tests 

global number_of_turns; % was defined in our main function (team6.m)

%% Beginning
if number_of_turns < 24
    depth = 5;
end

if number_of_turns >= 24 && number_of_turns < 30
    depth = 6;
end

%% Midgame
if time_left > 90
    if number_of_turns >= 30 && number_of_turns < 45
        depth = 7;
    end
    if number_of_turns == 45
        depth = 8;
    end
    if number_of_turns == 46
        depth = 9;
    end
    if number_of_turns == 47
        depth = 10;
    end
    if number_of_turns == 48
        depth = 11;
    end
elseif time_left <= 90 && time_left > 60 && number_of_turns >= 30 && number_of_turns < 49
    depth = 7;
elseif time_left <= 60 && number_of_turns >= 30 && number_of_turns < 49
    depth = 6;
end

%% Endgame (Perfect Game)
if number_of_turns >= 49
    if time_left > 65
        depth = 61 - number_of_turns;
        depth = min(11,depth);
    elseif time_left <= 65 && time_left > 55
        depth = 61 - number_of_turns;
        depth = min(9,depth);
    elseif time_left <= 55 && time_left > 45
        depth = 61 - number_of_turns;
        depth = min(8,depth);    
    elseif time_left <= 45 && time_left > 35
        depth = 61 - number_of_turns;
        depth = min(7,depth);
    elseif time_left <= 35
        depth = 61 - number_of_turns;
        depth = min(6,depth);
    end
end

%% Take time into account if we're running out of time
depth_time = 99;
if time_left < 25
    depth_time = 5;
    if time_left < 20
        depth_time = 4;
        if time_left < 15
            depth_time = 3;
            if time_left < 10
                depth_time = 2;
                if time_left < 5
                    depth_time = 1;
                end
            end
        end
    end
end

depth = min(depth, depth_time);

%% Display
% disp(['Depth: ' num2str(depth)])
% disp(['Round: ' num2str(nummer_of_turns)])

end