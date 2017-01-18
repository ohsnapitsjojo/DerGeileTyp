function [current_alpha, best_board] = NegamaxPruning(b,color,alpha,beta,depth)

best_board = b;
current_alpha = -inf;
if depth == 0
    current_alpha = EvaluateBoard(b,color);
else
    possible_boards = FindAllowedPositions(b, color);
    possible_moves = size(possible_boards,3);
    
    % Sorting of moves
    value = zeros(1, possible_moves);
    for k = 1:possible_moves
        value(k) = ValueOfBoard(possible_boards(:,:,k),color);
    end
    [test3, idx] = sort(value, 'descend');
    
    for n=1:possible_moves
        val = -NegamaxPruning(possible_boards(:,:,idx(n)),-color,-beta,-alpha,depth-1);
        % alpha-beta-cut-off
        if val > current_alpha
            best_board = possible_boards(:,:,idx(n));
            if val > alpha
                alpha = val;
            end
            current_alpha = val;
            if alpha >= beta
                break;
            end
        end
%         % Finisher
%         if sum(sum(possible_boards(:,:,idx(n))==-color))==0
%             current_alpha = inf;
%             disp('Perfect')
%             break;
%         end
    end
end
end