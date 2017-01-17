function [ h ] = JgetHeuristic( b, w, color )
%GETHEURISTIC Summary of this function goes here
%   Calculate final Heurisitic
 % Weights for Heueristics:
 % 1) Coint Parity 2) Mobility 3) Corner Possesion 4) Stability

    

 
    h = w(1)*hCoinParity( b,color ) + w(2)*hMobility(b,color) + ...
        w(3)*hCornersCaptured(b, color) + w(4)*JhStability(b,color) +w(5)*hStability(b,color) ;
    
    if getWinner(b) == -1*color
        h = -101;
        
    end
    

    
end

