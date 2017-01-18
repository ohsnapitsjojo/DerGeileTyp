function [ value_of_corners ] = ValueOfCorners(b)

%% Search for even and odd corners

% Define subareas
north_west = b(1:2,1:2);
south_west = b(7:8,1:2);
north_east = b(1:2,7:8);
south_east = b(7:8,7:8);

% Look if there is an even or odd number of stones
north_west_stones = sum(abs(north_west(north_west~=0)));
south_west_stones = sum(abs(south_west(south_west~=0)));
north_east_stones = sum(abs(north_east(north_east~=0)));
south_east_stones = sum(abs(south_east(south_east~=0)));

north_west_stones = 1-mod(north_west_stones,2); 
south_west_stones = 1-mod(south_west_stones,2); 
north_east_stones = 1-mod(north_east_stones,2); 
south_east_stones = 1-mod(south_east_stones,2); 

% Summary and calculate value
value_of_corners = sum(north_west_stones+south_west_stones+north_east_stones+south_east_stones);

end