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
% @todo impl5ement!
function [ max_depth ] = GC_getMaxDepth_lookuptable(t_game, round_no, dict_flag)
tic;

%the MaxDepth increases while round_no ins increasing!

persistent last_time;
persistent MaxDepth;
persistent deathvalue;
persistent lookuptable;
persistent tableiteration;
persistent Depth_history;

disp('MaxDepth_Debug: t_game:');
disp(t_game);
disp('MaxDepth_Debug: dict_flag:');
disp(dict_flag);


%%  Initialize:
%initialse variable last_time
if (isempty(last_time) || (abs(t_game - 180.) <= eps(180.)))
    % reset last_time if time is 180 seconds (new match begins).
    last_time = double(180)*ones(61,1);
    disp('MaxDepth_Debug: last_time reset:');
    disp(last_time);
    
    
else
    % just happy update
    last_time(round_no+1) = t_game;
    % disp('MaxDepth_Debug: las_time:');
    %disp(last_time);
    
end


%initialse variable lookuptable
if (isempty(lookuptable) || (abs(t_game - 180.) <= eps(180.)))
    % reset last_time if time is 180 seconds (new match begins).
    % maximales lookuptable
    %lookuptable = [ 0.05  0.08  1.6  6  33  44  92];
    %lookuptable =  [  0.05   0.08     1  3  5  10  20 30 40];
    lookuptable = zeros(61,10);
    disp('MaxDepth_Debug: lkoouptable:');
    disp(lookuptable);
    
end

% initialise the history of your MaxDepth
if (isempty(Depth_history) || (abs(t_game - 180.) <= eps(180.)))
    % reset last_time if time is 180 seconds (new match begins).
    Depth_history = zeros(61,1);
    disp('MaxDepth_Debug: Depth_history:');
    disp(Depth_history);
    
end

% initialise the history iteration
if (isempty(tableiteration) || (abs(t_game - 180.) <= eps(180.)))
    % reset last_time if time is 180 seconds (new match begins).
    tableiteration = ones(10);
    disp('MaxDepth_Debug: tableiteration:');
    disp(tableiteration);
    
end


if (isempty(deathvalue) || (abs(t_game - 180.) <= eps(180.)))
    % reset last_time if time is 180 seconds (new match begins).
    deathvalue = 0;
    disp('MaxDepth_Debug: deathvalue:');
    disp(deathvalue);
end

% initialise your MaxDepth
if (isempty(MaxDepth) || (abs(t_game - 180.) <= eps(180.)))
    % reset Maxdepth if time is 180 seconds (new match begins).
    MaxDepth = 6;
end

%%  Time and Round Calculations
%calculate the time your player needs for one move / round
if(round_no == 1)
    time_diff = 0.001;
else
    time_diff = last_time(round_no)-t_game;
    
    tableiteration(MaxDepth) = tableiteration(MaxDepth) + 1;
    
    if(time_diff > lookuptable(tableiteration, MaxDepth))
        if(dict_flag == 0 )
        
        lookuptable(tableiteration,MaxDepth) = time_diff;
        end
    end
end
disp('MaxDepth_Debug: last_time(round_no):');
disp(last_time(round_no));
disp('MaxDepth_Debug: time_diff:');
disp(time_diff);
disp('lookuptable(MaxDepth):');
disp(lookuptable(:,MaxDepth)');

mean_round_time = mean(lookuptable(:,MaxDepth));

%calculate time player needs for hole game if the searchdepth goes on
% if(time_diff > 1)
%     possible_rounds = ceil(t_game/time_diff);
% else
%     possible_rounds= 180;
% end
possible_rounds = ceil(t_game/mean_round_time);
disp('MaxDepth_Debug: possible_rounds');
disp(possible_rounds);


%calculate the maximum of rounds left in the game
rounds_left = 32 - round_no;
disp('MaxDepth_Debug: rounds_left:');
disp(rounds_left);
disp('MaxDepth_Debug: round_no:');
disp(round_no);

%% Set your roundover/equal/undershot, winnable and pair flags


% get the overhot on rounds left in for the game if algorithm
% performance persists
if(possible_rounds > rounds_left)
    rounds_overshot = possible_rounds - rounds_left;
    
    rounds_undershot = 0;
    rounds_equal= 0;
    
    
    disp('MaxDepth_Debug: rounds_overshot');
    disp(rounds_overshot);
    
else if(possible_rounds == rounds_left)
        
        rounds_equal= 1;
        rounds_overshot = 0;
        rounds_undershot = 0;
        
        
        disp('MaxDepth_Debug: rounds_equal');
        disp(rounds_equal);
        
    else if(possible_rounds < rounds_left)
            rounds_undershot = rounds_left - possible_rounds;
            
            rounds_overshot = 0;
            rounds_equal= 0;
            
            disp('MaxDepth_Debug: rounds_undershot');
            disp(rounds_undershot);
            
        end
    end
end



pair = 0;
% get pair unpair round
if(round_no/2 == 0)
    pair = 1;
end

if( dict_flag == 0) % end is under calculations
%% Calculate your MaxDepth, change it proove it whatever

disp('MaxDepth_Debug: max_depth before calculation and output:');
disp(MaxDepth);

% change death value and MaxDepth in addition depending on stuff like round_overshot
if( rounds_undershot > 0 && rounds_overshot == 0 ...
        && rounds_equal == 0 && round_no > 5)
    
    disp('deathvalue before');
    disp(deathvalue);disp('MaxDepth_Debug: max_depth before output:');
    disp(MaxDepth); 
    
    deathvalue = deathvalue -0.24;
    
    disp('deathvalue after');
    disp(deathvalue);
    
    %  MaxDepth = MaxDepth -1;
    
    
else if(rounds_equal == 1)
        
        disp('deathvalue equal');
    disp(deathvalue);
        
        
    else if(rounds_overshot > 0 && rounds_undershot == 0 && ...
                rounds_equal == 0 && round_no > 5 && pair == 0)
            
           
            deathvalue = deathvalue + 0.12;
            %        MaxDepth = MaxDepth +1;
            
                disp('deathvalue after');
    disp(deathvalue);
                               
        end
    end
end

%MaxDepth addjustion: lol just set it
MaxDepth = MaxDepth + round(deathvalue);

if(deathvalue >= 0.5)
    deathvalue = 0;
end

% set time_diff last round limit to MaxDepth
if(time_diff > 8)
    
    MaxDepth = MaxDepth -1;
    
end

%set a minimum limit to MaxDepth
if(MaxDepth < 4)
    
    MaxDepth = 4;
    
end

% set a maximum limit to MaxDepth
if(MaxDepth > 8)
    
    MaxDepth = 8;
    
end

% set a safety limit depending on time for the end
if ( t_game < 90)
    
    MaxDepth = 5;
    if( t_game < 60)
        
        Maxdepth = 4;
    end
%     if( t_game < 30)
%         Maxdetph = 4;
%     end
end



% set a safety limit depending on rounds for the end
if ( round_no > 24)
    
   if( MaxDepth > (32 - round_no));
      
       MaxDepth = 32 - round_no;
       
   end
end



end % from if dict_flag

%% Make your statistics

Depth_history(round_no) = MaxDepth;

disp('MaxDepth_Debug: mean value of Depth');
disp(mean(Depth_history(1:round_no),1));
disp('MaxDepth_Debug: standard deviation of Depth');
disp(std(Depth_history(1:round_no),1));

%%  Make it ready for the output


max_depth = MaxDepth; %set persistent variable to output
disp('MaxDepth_Debug: after output:');
disp(max_depth);

disp('MaxDepth_Debug: t_game:');
disp(t_game);

timegetDepth = toc;
disp('timegetDepth:')
disp(timegetDepth);
end %from function
