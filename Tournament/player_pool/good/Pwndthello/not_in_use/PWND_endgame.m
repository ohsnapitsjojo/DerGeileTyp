
function sc = negamax_endgame(b, color, init_color, num_discs_to_place, init_num_discs_to_place)
%disp(['in minimax_max'])

global EndgameMoveTable;
global EndgameScore;
global row_idx;
persistent flag;

sc = -inf;

if num_discs_to_place == init_num_discs_to_place
  flag = 0;
end

if num_discs_to_place == 0
    sc = abs(sum(sum(b(b == init_color))));
    row_idx = row_idx + 1;
else
    [pos, B] = PWND_findAllowedPositions2(b, color);
    if isempty(pos)
        zero_vec = cellfun(@(x) isequal(x, [0 0]), EndgameMoveTable(row_idx, :));
        flag = 1;
        if sum(zero_vec) >= 1
            EndgameMoveTable{row_idx, find(zero_vec, 1, 'last')+1} = [0 0];
            sc = abs(sum(sum(b(b == init_color))));
            EndgameScore(row_idx) = sc;
            row_idx = row_idx + 1;
        else
            EndgameMoveTable{row_idx, init_num_discs_to_place + 1 - num_discs_to_place} = [0 0];
            sc = negamax_endgame(b, -color, init_color, num_discs_to_place, init_num_discs_to_place+1);
            EndgameScore(row_idx) = sc;
        end
    else
        for ii=1:size(pos, 1)
            %disp(['num_discs_to_place:', num2str(num_discs_to_place)]);
            if flag == 1
              col_idx = init_num_discs_to_place + 2 - num_discs_to_place;
              flag = 0;
            else
              col_idx = init_num_discs_to_place + 1 - num_discs_to_place;
            end
            %disp(['row = ', num2str(row_idx), 'col= ', num2str(col_idx)]);
            EndgameMoveTable{row_idx, col_idx} = pos(ii, :);
            sc = negamax_endgame(B(:,:,ii), -color, init_color, num_discs_to_place-1, init_num_discs_to_place);
            EndgameScore(row_idx) = sc;
        end
    end
end


end