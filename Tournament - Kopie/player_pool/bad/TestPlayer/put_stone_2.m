function [result_field] = put_stone_2(field, m, n, m_dir, n_dir, colour)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
 
if field(m + m_dir, n + n_dir) == (colour * (-1))
    field(m + m_dir, n + n_dir) = colour;
    result_field = put_stone_2(field, m + m_dir, n + n_dir, m_dir, n_dir, colour);
    return;
elseif field(m + m_dir, n + n_dir) == colour
    result_field = field;
    return;
end


end

