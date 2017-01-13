function [ m ] = alphaBeta( b, color, depth, w )

    [~,m] = alphaBetaPruning( b, depth, -inf, +inf, color, color, w, true);
end

