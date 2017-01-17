function [ h ] = getHeuristic( b, w, color )
%GETHEURISTIC Summary of this function goes here
%   Calculate final Heurisitic
   h = w(1)* hCoinParity( b,color )+w(2)*hMobility(b,color)+ w(3)*hCornersCaptured(b,color)+w(4)*hStability(b,color);
   %h = w(1)* hCoinParity( b,color );
end

