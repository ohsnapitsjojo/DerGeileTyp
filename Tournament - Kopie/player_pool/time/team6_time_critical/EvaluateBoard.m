function [ value ] = EvaluateBoard(b,color)

%% Select different weighting factor according to the number of stones
 number_of_stones = sum(sum(b ~= 0));

 if (number_of_stones < 16)
    factor_value_of_density = 0;
    factor_value_of_number = 0;
    factor_value_of_board = 1;
    factor_value_of_empty_fields = 2.5;
    factor_value_of_constant_regions = 1000;
    factor_value_of_edges = 2000;
    factor_value_of_corners = 1000; % former 1500 perfect possible against PlayerF
    factor_value_of_cardinal_directions = 0; 
    factor_value_of_lines = 0;
    factor_value_of_evaporation = 0;
 elseif (number_of_stones < 32)
    factor_value_of_density = 0;
    factor_value_of_number = 0.4;
    factor_value_of_board = 0.8;
    factor_value_of_empty_fields = 5;
    factor_value_of_constant_regions = 1000;
    factor_value_of_edges = 2000;
    factor_value_of_corners = 1000; % former 1500 perfect possible against PlayerF
    factor_value_of_cardinal_directions = 0; 
    factor_value_of_lines = 0;
    factor_value_of_evaporation = 0;
 elseif (number_of_stones < 48)
    factor_value_of_density = 0;
    factor_value_of_number = 0.6;
    factor_value_of_board = 0.6;
    factor_value_of_empty_fields = 2.5;
    factor_value_of_constant_regions = 1000;
    factor_value_of_edges = 2000;
    factor_value_of_corners = 1000; % former 1500 perfect possible against PlayerF
    factor_value_of_cardinal_directions = 0; 
    factor_value_of_lines = 0;
    factor_value_of_evaporation = 0;
else   
    factor_value_of_density = 0;
    factor_value_of_number = 1;
    factor_value_of_board = 0;
    factor_value_of_empty_fields = 0;
    factor_value_of_constant_regions = 0;
    factor_value_of_edges = 0;
    factor_value_of_corners = 0;
    factor_value_of_cardinal_directions = 0;
    factor_value_of_lines = 0;
    factor_value_of_evaporation = 0;
end

%% Value of Denstiy
if factor_value_of_density ~= 0
    value_of_density = ValueOfDensity(b,color);
else
    value_of_density = 0;
end

%% Value of Nummers
if factor_value_of_number ~= 0
    value_of_numbers = sum(sum(b==color))-sum(sum(b==-color));
else
    value_of_numbers = 0;
end

%% Value of the Board
if factor_value_of_board ~= 0
    value_of_board = ValueOfBoard(b,color)-ValueOfBoard(b,-color);
else
    value_of_board = 0;
end

%% Value of Empty Fields
if factor_value_of_empty_fields ~= 0
    value_of_empty_fields = ValueOfEmptyFields(b,color)-ValueOfEmptyFields(b,-color);
else
    value_of_empty_fields = 0;
end

%% Value of Constant Regions
if factor_value_of_constant_regions ~= 0
    value_of_constant_regions = ValueOfConstantRegions(b,color)-ValueOfConstantRegions(b,color);
else
    value_of_constant_regions = 0;
end

%% Value of Edges
if factor_value_of_edges ~= 0
    value_of_edges = ValueOfEdges(b,color);
else
    value_of_edges = 0;
end

%% Value of Lines
if factor_value_of_lines ~= 0
    value_of_lines = ValueOfLines(b,color);
else
    value_of_lines = 0;    
end

%% Value of Corners
if factor_value_of_corners ~= 0
    value_of_corners = ValueOfCorners(b,color);
else
    value_of_corners = 0;
end

%% Value of Cardinal Directions
if factor_value_of_cardinal_directions ~= 0
    value_of_cardinal_directions = ValueOfCardinalDirections(b,color);
else
    value_of_cardinal_directions = 0;
end

%% Value of Evaporation
if factor_value_of_evaporation ~= 0
    value_of_evaporation = ValueOfEvaporation(b,color);
else
    value_of_evaporation = 0;
end

%% Summarize of all values according to the different weighting factors
value = value_of_density*factor_value_of_density + ...
        value_of_numbers*factor_value_of_number + ...
        value_of_board*factor_value_of_board + ...
        value_of_constant_regions*factor_value_of_constant_regions + ...
        value_of_empty_fields*factor_value_of_empty_fields + ...
        value_of_lines*factor_value_of_lines + ...
        value_of_edges*factor_value_of_edges + ...
        value_of_corners*factor_value_of_corners + ...
        value_of_cardinal_directions*factor_value_of_cardinal_directions + ...
        value_of_evaporation*factor_value_of_evaporation;
    
% % Degugg    
% disp(' ')
% disp(['value_of_density: ' num2str(value_of_density*factor_value_of_density)])
% disp(['value_of_board: ' num2str(value_of_board*factor_value_of_board)])
% disp(['value_of_numbers: ' num2str(value_of_numbers*factor_value_of_number)])
% disp(['value_of_constant_regions: ' num2str(value_of_constant_regions*factor_value_of_constant_regions)])
% disp(['value_of_empty_fields: ' num2str(value_of_empty_fields*factor_value_of_empty_fields)])
% disp(['value_of_lines: ' num2str(value_of_lines*factor_value_of_lines)])
% disp(['value_of_edges: ' num2str(value_of_edges*factor_value_of_edges)])
% disp(['value_of_corners: ' num2str(value_of_corners*factor_value_of_corners)])
% disp(['value_of_cardinal_directions: ' num2str(value_of_cardinal_direction*factor_value_of_cardinal_direction)])
% disp(['value_of_evaporation: ' num2str( value_of_evaporation*factor_value_of_evaporation)])
% disp(['Summe: ' num2str(value)])
% disp(['Step: ' num2str(number_of_stones)])
end

