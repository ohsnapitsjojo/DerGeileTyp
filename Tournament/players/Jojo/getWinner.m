function [ winner ] = getWinner( b )
% get Winner
% returns winner, if no winner -> returns 0
    nMove1 = allPossible(b, -1);
    nMove2 = allPossible(b, 1);
    
    if isempty(nMove1) == 1 && isempty(nMove2) == 1
        h = hCoinParity( b, 1 );
        if h == 0
            winner = 0;
            return
        end
        winner = sign(h);
        
    else
        winner = 0;

end

