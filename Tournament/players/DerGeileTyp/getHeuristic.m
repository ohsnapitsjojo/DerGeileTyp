function [ h ] = getHeuristic( b, w, color )
%GETHEURISTIC Summary of this function goes here
%   Calculate final Heurisitic
    h = w(1)* hCoinParity( b,color );

end

