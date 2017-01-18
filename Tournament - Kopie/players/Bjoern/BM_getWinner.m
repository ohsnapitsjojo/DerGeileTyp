function [ winner ] = BM_getWinner( b )
% get Winner
% returns winner, if no winner -> returns 0
    nMove1 = BM_allPossible(b, -1);
    nMove2 = BM_allPossible(b, 1);
    
    if isempty(nMove1) == 1 && isempty(nMove2) == 1
        h = BM_hCoinParity( b, 1 );
        if h == 0
            winner = 0;
            return
        end
        winner = sign(h);
        
    else
        winner = 0;

end

