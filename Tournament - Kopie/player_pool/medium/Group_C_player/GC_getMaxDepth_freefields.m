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
function [ MaxDepth ] = GC_getMaxDepth_freefields(b, t_game, round_no, dict_flag)

%the MaxDepth increases while round_no ins increasing!

disp('MaxDepth_Debug: t_game:');
disp(t_game);
disp('MaxDepth_Debug: round_no:');
disp(round_no);
disp('MaxDepth_Debug: dict_flag:');
disp(dict_flag);


%% Calculate your MaxDepth, change it proove it whatever
if( dict_flag == 0) % end is under calculations
    
    % get the free fields
    
    freefields = sum(sum(b == 0));
    
    disp('Number of free fields');
    disp(freefields);
    
    % now set the max depth depending on result
    
  
        
if(freefields < 11)
        
        MaxDepth = 9;
        disp('MaxDepth_Debug: after output:');
        disp(MaxDepth);
        
    elseif(freefields < 12)
        
        MaxDepth = 8;
        disp('MaxDepth_Debug: after output:');
        disp(MaxDepth);
        
    elseif(freefields <  13)
        
        MaxDepth = 7;
        disp('MaxDepth_Debug: after output:');
        disp(MaxDepth);
        
        % OPTIONAL:
        %         if(t_game > 100)
        %             MaxDepth = 6;
        %         end
        
    elseif(freefields < 16)
        
        MaxDepth = 6;
        disp('MaxDepth_Debug: after output:');
        disp(MaxDepth);
        
        % OPTIONAL:
        %         if(t_game > 100)
        %             MaxDepth = 5;
        %         end
        
    elseif(freefields < 20)
        
        MaxDepth = 5;
        disp('MaxDepth_Debug: after output:');
        disp(MaxDepth);
        
        % OPTIONAL:
        %         if(t_game > 100)
        %             MaxDepth = 4;
        %         end
        
    elseif(freefields < 30)
        
        MaxDepth = 4;
        disp('MaxDepth_Debug: after output:');
        disp(MaxDepth);
        
        % OPTIONAL:
        %         if(t_game > 100)
        %             MaxDepth = 3;
        %         end
        
        
    elseif(freefields < 64)
        
        MaxDepth = 3;
        disp('MaxDepth_Debug: after output:');
        disp(MaxDepth);
        
    end
    
    %     %OPTIONAL: set a safety limit depending on rounds for the end
    %     if ( round_no > 26)
    %
    %         if( MaxDepth > (32 - round_no));
    %
    %             MaxDepth = 32 - round_no;
    %
    %         end
    %     end
    
    
else % case: if dictionary is of. MaxDepth should be NOT Zero "0" . Will
    %                             error in the alphabetaalgorithm
    
    MaxDepth = 3;
    disp('Max_Depth_Debug: dictionary still on');
    
    
end % from if dict_flag

%% end of function
end %from function
