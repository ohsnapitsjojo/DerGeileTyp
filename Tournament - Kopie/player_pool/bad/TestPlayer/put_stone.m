function [modified_field] = put_stone(field, stone_pos, colour)
%field: 8x8 Matrix, Othello Feld
%
%stone_pos: 1x2 Matrix, Koordinaten des gesetzten Stein
%
%colour: Farbe des Steins der gesetzt wird

new_stone = zeros(8,8);
new_stone(stone_pos(1), stone_pos(2)) = colour;
modified_field = field + new_stone;

for i = -1:1
    for j = -1:1
        if free2set_2(field,stone_pos(1),stone_pos(2),i,j,colour,1) == 1
            modified_field = put_stone_2(modified_field, stone_pos(1), stone_pos(2), i, j, colour);
        end
    end
end


end

