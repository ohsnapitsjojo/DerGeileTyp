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
function [ max_depth ] = GC_getMaxDepth_calctime(t_game, round_no, dict_flag)
tic;
%%the MaxDepth increases while round_no ins increasing!

persistent last_time;
persistent MaxDepth;

disp('debug: t_game:');
disp(t_game);

disp('MaxDepth_Debug: t_game:');
disp(t_game);
disp('MaxDepth_Debug: dict_flag:');
disp(dict_flag);

%% Initialise
%initialse variable last_time
if (isempty(last_time) || (abs(t_game - 180.) <= eps(180.)))
    % reset last_time if time is 180 seconds (new match begins).
    last_time = double(180)*ones(61,1);
    disp('debug: last_time reset:');
    disp(last_time);
    
else
    % just happy update
    last_time(round_no+1) = t_game;
    % disp('debug: las_time:');
    %disp(last_time);
    
end

if (isempty(MaxDepth) || (abs(t_game - 180.) <= eps(180.)))
    % reset Maxdepth if time is 180 seconds (new match begins).
    MaxDepth = 5;
end

%% Round and Time Calculations
%calculate the time your player needs for one move / round
if(round_no==1)
    time_diff = 0.001;
else
    time_diff = last_time(round_no)-t_game;
end
disp('debug: last_time(round_no):');
disp(last_time(round_no));
disp('debug: time_diff:');
disp(time_diff);

%calculate time player needs for hole game if the searchdepth goes on
if(time_diff > 1)
    possible_rounds = ceil(t_game/time_diff);
else
    possible_rounds= 180;
end
disp('debug: possible_rounds');
disp(possible_rounds);


%calculate the maximum of rounds left in the game
rounds_left = 32 - round_no;
disp('debug: rounds_left:');
disp(rounds_left);
disp('debug: round_no:');
disp(round_no);



if( dict_flag == 0) % end is under calculations
    %% Determine if there is an overshot on rounds based on prediction
    % get the overhot on rounds left in for the game if algorithm
    % performance persists
    if(possible_rounds > rounds_left)
        rounds_overshot = possible_rounds - rounds_left;
        
        rounds_undershot = 0;
        rounds_equal= 0;
        
        
        disp('debug: rounds_overshot');
        disp(rounds_overshot);
        
    else if(possible_rounds == rounds_left)
            
            rounds_equal= 1;
            rounds_overshot = 0;
            rounds_undershot = 0;
            
            
            disp('debug: rounds_equal');
            disp(rounds_equal);
            
        else if(possible_rounds < rounds_left)
                rounds_undershot = rounds_left - possible_rounds;
                
                rounds_overshot = 0;
                rounds_equal= 0;
                
                disp('debug: rounds_undershot');
                disp(rounds_undershot);
                
            end
        end
    end
    
    
    
    
    %% MaxDepth calculations
    % change MaxDepth depending on stuff like round_overshot
    if( rounds_undershot > 0 && rounds_overshot == 0 && rounds_equal == 0)
        
        MaxDepth = MaxDepth -0.24;
        
        
    elseif(rounds_overshot > 0 && rounds_undershot == 0 ...
            &&  rounds_equal == 0)
        
        MaxDepth = MaxDepth +0.16;
        
    end % end form calculations


% set time_diff last round limit to MaxDepth
if(time_diff > 8)
    
    MaxDepth = MaxDepth -1;
    
end
    
% set a minimum limit to MaxDepth
if(MaxDepth < 5)
    
    MaxDepth = 4;
    
end


% set a maximum limit to MaxDepth
if(MaxDepth > 8)
    
    MaxDepth = 8;
    
end

% set a safety limit depending on time for the end
if ( t_game < 90)
    
    MaxDepth = 6;
    if( t_game < 60)
        
        Maxdepth = 5;
    end
    if( t_game < 30)
        Maxdetph = 4;
    end
end

% set a safety limit depending on rounds for the end
if ( round_no > 24)
    
   if( MaxDepth > (32 - round_no));
      
       MaxDepth = 32 - round_no;
       
   end
end


end % from if dict_flag

%%  Make it ready for the Output

max_depth = MaxDepth; %set persistent variable to output
max_depth = round(MaxDepth);

disp('debug: t_game:');
disp(t_game);

timegetDepth = toc;
disp('timegetDepth:')
disp(timegetDepth);
end %from function
