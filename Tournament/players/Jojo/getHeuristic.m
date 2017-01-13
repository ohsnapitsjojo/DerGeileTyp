function [ h ] = getHeuristic( b, w, color )
%GETHEURISTIC Summary of this function goes here
%   Calculate final Heurisitic
 % Weights for Heueristics:
 % 1) Coint Parity 2) Mobility 3) Corner Possesion 4) Stability
    if getWinner(b) ~= color
        h = -100;
    end
 
    h = w(1)*hCoinParity( b,color ) + w(2)*hMobility(b,color) + ...
        w(3)*hCornersCaptured(b, color) + w(4)*hStability(b,color) ;
    
end

