function [ turn ] = getTurn( b )
% returns the current turn number

    a = b == 0;
    turn = 60 - sum(sum(a));
    
end

