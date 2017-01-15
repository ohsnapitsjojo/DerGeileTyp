function [ h ] = getHeuristic( b, w, color )
%  Calculate final Heurisitic
       winner = getWinner(b);
    if winner == -color
        h = -inf;
    elseif winner == color
        h = inf;
    else
        h = w(1)*hCoinParity(b,color)+w(2)*hMobility(b,color)+...
            w(3)*hCornersCaptured(b,color)+w(4)*hStability(b,color); 
    end
end

