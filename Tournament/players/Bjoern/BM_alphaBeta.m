function [ m ] = BM_alphaBeta( b, color, depth, w )
% Berechnet den Zug m eine Minimax Agenten mit alpha beta pruning
    [~,m] = BM_alphaBetaPruning( b, depth, -inf, +inf, color, color, w, true);
end

