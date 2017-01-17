function [v, b_best] = DGG_negamax(b, player, alpha, beta, depth, weights)
% This function implements a negamax algorithm with alpha-beta-pruning.

%% init negamax
% init value v
v = -inf;

% init b as best board
b_best = b;

%% if leaf calculate board value
if depth==0 
    v = DGG_getBoardValue(b, player, weights);
    return;
end

% calculate all valid moves
[b_new, moves] = DGG_legalMoves(b, player);

% if no more move possible, calculate board value
if isempty(moves)  
    v = DGG_getBoardValue(b, player, weights);
    return;
end

%% build negamax search-tree
for idx=1:numel(moves)
    % get value of deeper level
    v_new = -DGG_negamax( b_new(:,:,idx), -player, -beta, -alpha, depth-1, weights);
    
    % cut off with alpha-beta-pruning to improve efficiency
    if v_new > v 
        b_best = b_new(:,:,idx);
        if v_new > alpha
            alpha = v_new;
        end
        v = v_new;
    end
    if v >= beta
        break;
    end
end




end