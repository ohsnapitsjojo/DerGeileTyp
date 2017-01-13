function [ value_of_cardinal_directions ] = ValueOfCardinalDirections(b)

%%%%%%%%%%%%%%%%%%%%%% function is not used! %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
% function was initially used in EvaluateBoard(), but did not improve our%
% player; intention: see information (%%) at end of file                 %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define subareas
north = b(1,4:5);
south = b(8,4:5);
west = b(4:5,1);
east = b(4:5,8);

% Look if there is an even or odd number of stones in cardinal directions
north_stones = sum(abs(north(north~=0)));
south_stones = sum(abs(south(south~=0)));
west_stones = sum(abs(west(west~=0)));
east_stones = sum(abs(east(east~=0)));

% Just count odd or even number of stones
north_stones = 1-mod(north_stones,2); 
south_stones = 1-mod(south_stones,2); 
west_stones = 1-mod(west_stones,2); 
east_stones = 1-mod(east_stones,2); 

% Summarize and calculate value
value_of_cardinal_directions = sum(north_stones+south_stones+west_stones+east_stones);

%% Information:
% Nicht genutzt, da die Funktion ValueOfEdges generischer ist und auch    %
% andere Faelle abdeckt.                                                  %

end

