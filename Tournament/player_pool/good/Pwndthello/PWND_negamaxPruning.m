
function [localAlpha, bestBoard] = PWND_negamaxPruning(b, color, alpha, beta, depth)
%% Implements the standard negamax algorithm with alpha beta pruning as found in many CS paper and articles
% 
% fst, 06/12/2012 - yields the same results as the previous minimax and negamax
% implementations; hence, this should be fine

bestBoard = b;
localAlpha = -inf;

if depth == 0
    localAlpha = PWND_evaluateBoard(b, color);
    %disp(['Returning a value of ' num2str(localAlpha) ' for color ' num2str(color)]);
else
    % here we test whether there are any allowed positions for the given
    % color; besides, we also get the boards, when the corresponding moves
    % has been performed - that's quite neat.
    [pos, B] = PWND_findAllowedPositions(b, color);
    if isempty(pos)
        % if this condition holds true, it usually means that
        % our search depth is obviously higher than the potential
        % number of moves to make
        %disp([mfilename, ': no moves possible'])
        localAlpha = PWND_evaluateBoard(b, color);
        return;
    end
    % obviously, there are some moves to make, let's go diving into it
    for ii=1:size(pos, 1)
        val = -PWND_negamaxPruning(B(:,:,ii), -color, -beta, -alpha, depth-1);
        
        % implementing the cut-offs which ensure the speed-up compared to
        % the regular version
        if val > localAlpha
            bestBoard = B(:,:,ii);
            if val > alpha
                alpha = val;
            end
            localAlpha = val;
            if alpha >= beta
                break;
            end
        end
    end
end