function [points] = bewerten(field, color)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    field_2 = (field == color);
    field_3 = (field == (color * -1));
    field = free2set(field, color);
    points = 3*sum(field_2(:)) - sum(field_3(:)) + sum(field(:)); 
end

