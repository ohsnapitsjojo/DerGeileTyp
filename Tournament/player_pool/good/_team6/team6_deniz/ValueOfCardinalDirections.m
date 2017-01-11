function [ value_of_cardinal_directions ] = ValueOfCardinalDirections(b,color)

%% Search for even and odd areas in cardinal directions

% Define subareas
north = b(1,4:5);
south = b(8,4:5);
west = b(4:5,1);
east = b(4:5,8);

% Look if there is a even or odd number of stones
north_stones = sum(abs(north(north~=0)));
south_stones = sum(abs(south(south~=0)));
west_stones = sum(abs(west(west~=0)));
east_stones = sum(abs(east(east~=0)));

% Just count odd or even number of stones
north_stones = 1-mod(north_stones,2); 
south_stones = 1-mod(south_stones,2); 
west_stones = 1-mod(west_stones,2); 
east_stones = 1-mod(east_stones,2); 

% Summarize
value_of_cardinal_directions = sum(north_stones+south_stones+west_stones+east_stones);

end

