function [points] = minValue(field, colour, depth)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    
    points = 65000;
    [free_fields_matrix, free_fields_koord] = free2set(field, colour);
    possible_moves = size(free_fields_koord);
    for i = 1:possible_moves(1)
        modified_field = put_stone(field, free_fields_koord(i,:), colour);
        
        if depth <= 1
            act_points = bewerten(modified_field, colour);
        else
            act_points = maxValue(modified_field, colour*(-1), depth - 1);
        end
        
        if act_points < points
            points = act_points;
        end
        
    end

end

