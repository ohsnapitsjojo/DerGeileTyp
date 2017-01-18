function [ value ] = EvaluateBoard(b,color)

%% Select different weighting factor according to the number of stones
%  factors have been tested several times and provide optimal results in
%  final tests

number_of_stones = sum(sum(b ~= 0));

if (number_of_stones < 56)
    factor_value_of_number = 0;
    factor_value_of_board = 1;
    factor_value_of_empty_fields = 4;
    factor_value_of_constant_regions = 2000;
    factor_value_of_edges = 2000;
    factor_value_of_corners = 1000;
    factor_value_of_lines = 0;
else
    factor_value_of_number = 1;
    factor_value_of_board = 0;
    factor_value_of_empty_fields = 0;
    factor_value_of_constant_regions = 0;
    factor_value_of_edges = 0;
    factor_value_of_corners = 0;
    factor_value_of_lines = 0;
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
    value_of_corners = ValueOfCorners(b);
else
    value_of_corners = 0;
end

%% Summary of all values according to the different weighting factors
value = value_of_numbers*factor_value_of_number + ...
        value_of_board*factor_value_of_board + ...
        value_of_constant_regions*factor_value_of_constant_regions + ...
        value_of_empty_fields*factor_value_of_empty_fields + ...
        value_of_lines*factor_value_of_lines + ...
        value_of_edges*factor_value_of_edges + ...
        value_of_corners*factor_value_of_corners;

% For debugging proposal only
% disp(' ')
% disp(['value_of_board: ' num2str(value_of_board*factor_value_of_board)])
% disp(['value_of_numbers: ' num2str(value_of_numbers*factor_value_of_number)])
% disp(['value_of_constant_regions: ' num2str(value_of_constant_regions*factor_value_of_constant_regions)])
% disp(['value_of_empty_fields: ' num2str(value_of_empty_fields*factor_value_of_empty_fields)])
% disp(['value_of_lines: ' num2str(value_of_lines*factor_value_of_lines)])
% disp(['value_of_edges: ' num2str(value_of_edges*factor_value_of_edges)])
% disp(['value_of_corners: ' num2str(value_of_corners*factor_value_of_corners)])
% disp(['Summe: ' num2str(value)])
% disp(['Step: ' num2str(number_of_stones)])
end

