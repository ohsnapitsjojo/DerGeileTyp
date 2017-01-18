% @brief Returns the current round number.
% 
% Effectively this function is only counting how many times it was called.
% This is done by
% 
% @author Martin Becker
% @date 2011-Jan-05
% 
% @param t time. Used to recognize when a new round begins. It is assumed
% that t=180 (respecting precision error).
% 
% @retval roundno a positive, nonzero integer value of type uint16, representing the
% current round number. If no prior function call with a resetRounds took place,
% the function starts counting at one. The value reflects ONLY how many
% times it was my player's turn, NOT including the opponent.
% 
function [ roundno ] = GC_getRoundNumber(t)

    persistent internalCounter;    
    
    if (isempty(internalCounter) || (abs(t - 180.) <= eps(180.)))
        % reset counter if time is 180 seconds (new match begins).
        internalCounter = uint16(1);
    else
        % just happy counting
        internalCounter = internalCounter + 1;        
    end
    roundno = internalCounter;