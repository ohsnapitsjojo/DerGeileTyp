function argout = negamax_test( b, color, depth, init_depth )
% at bottom of tree
if depth == 0
    % the coeff "color" determines if an evaluation is done for oneself or
    % for the opponents move
    argout = evaluateBoard(b, color);
    return;
end
max = -inf;
idx = findAllowedPositions(b, color);
% for each allowed move, call recursively negamax, with switched sign and
% reduced search depth
for i = 1:length(idx)
    % get new board for a move
    b1 = makeMove( b, -color, idx(i,1), idx(i,2) );
    score = -negamax_test( b1, -color, depth-1, init_depth );
    % undo move to invoke negamax correctly in the next iteration
%     b2 = undoMove( b1, -color, idx(i,1), idx(i,2) );
%     if ~all( all( b2 == b1))
%         b1
%         b2
%         error('undoMove - Funktion erzeugt falsches Ergebnis');
%     else
%         b = b2;
%     end
    % throw error if old board does not match
    if score > max
        % store best value only if we're in a depth > depth-1
        if depth ~= init_depth
            max = score;
            argout = max;
        else
            % if at depth == init_depth, return move / board
            argout = makeMove( b, color, idx(i,1), idx(i,2) );
        end
    end   
end

%return max;

function score = evaluateBoard(b, color)
% simple weighting all number of own tokens
score = numel( b ( b == color ) );