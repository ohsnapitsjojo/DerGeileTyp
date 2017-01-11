function [ value_of_parity ] = ValueOfParity(b,color)

%% Explain... Topic...

value_of_parity = 0;

% Find all univistited regions
unvistited_regions=(b==0);

% Find out if the regions are even or odd
[region,number_of_regions]=bwlabel(unvistited_regions,4);
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