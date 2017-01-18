function [v, b_best, numNodes] = DGG_negamax(b, player, alpha, beta, depth, weights, prior_moves, maxTime, tStart)
% This function implements a negamax algorithm with alpha-beta-pruning.

%% init negamax
% init value v
v = -inf;

% init b as best board
b_best = b;

% take time
timeSpend = toc(tStart);

numNodes = 0;

%% if leaf calculate board value
if depth==0 || timeSpend > maxTime
    numNodes = 1;
    v = DGG_getLeafValue(b, player, weights, prior_moves);
    return;
end

% calculate all valid moves
[b_new, moves] = DGG_legalMoves(b, player);

% if no more move possible, calculate board value
if isempty(moves)  
    numNodes = 1;
    v = DGG_getLeafValue(b, player, weights, prior_moves);
    return;
end

% sort children nodes
v_nodes = zeros(1, numel(moves));
for idx = 1:numel(moves)
    v_nodes(idx) = DGG_getNodeValue(b_new(:,:,idx), player);
end
[~, idx_sorted] = sort(v_nodes, 'descend');


%% build negamax search-tree
for idx=1:numel(moves)
    
    % get value of deeper level
    [v_new,~,numNodesChild] = DGG_negamax( b_new(:,:,idx_sorted(idx)), -player, -beta, -alpha, depth-1, weights, moves, maxTime, tStart);
    v_new = -v_new;
    numNodes = numNodes+numNodesChild;
    
    % cut off with alpha-beta-pruning to improve efficiency
    if v_new > v 
        b_best = b_new(:,:,idx_sorted(idx));
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