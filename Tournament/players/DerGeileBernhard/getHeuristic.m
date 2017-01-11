function [ h ] = getHeuristic( b, w, color )
%GETHEURISTIC Summary of this function goes here
%   Calculate final Heurisitic
    winner = getWinner(b);
    if winner == -color
        h = -100;
    elseif winner == color
        h = 100;
    else
        h = w(1)*hCoinParity(b,color)+w(2)*hMobility(b,color)+...
            w(3)*hCornersCaptured(b,color)+w(4)*hStability(b,color); 
    end
end

