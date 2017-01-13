function [ m ] = alphaBeta( b, color, depth, w )
%ALPHABETA Summary of this function goes here
%   Detailed explanation goes here


    [~,m] = alphaBetaPruning( b, depth, -inf, +inf, color, color, w, true);

end

