function [ value_of_parity ] = ValueOfParity(b)

%%%%%%%%%%%%%%%%%%%%%% function is not used! %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
% function was initially used in EvaluateBoard(), but did not improve our%
% player; intention: calculate parity regions and add to value of board. %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize return parameter
value_of_parity = 0;

% Find all unvistited regions
unvistited_regions=(b==0);

% bwlabel finds all 4-connected objects in unvisited_regions
[region,number_of_regions]=bwlabel(unvistited_regions,4);

% check all found regions concerning the number of free fields;
% if number_of_free_fields is even, increment our value_of_parity;
% otherwise value_of_parity will be reduced.
for k = 1:number_of_regions
    current_region=(region==k);
    number_of_free_fields = sum(sum(current_region));
    if (mod(number_of_free_fields,2))
        value_of_parity = value_of_parity + 1;
    else
        value_of_parity = value_of_parity - 1;
    end
end
end