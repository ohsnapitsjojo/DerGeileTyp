function value_of_constant_region = ValueOfConstantRegions(b,color)

% Calculation of all constant regions, i.e. stones that can't be flipped
%  anymore by opponent

% Definition of empty boards
NorthWest = zeros(8,8);
NorthEast = zeros(8,8);
SouthWest = zeros(8,8);
SouthEast = zeros(8,8);

% we check constant regions/stones around the corners - but only if the
% corner is possessed by us! check column-wise and change column if there's
% no stone of use anymore

% North-West-Corner
if b(1,1) == color
    max_colum = 7;           
    for i = 1:7
        for j = 1:max_colum
            if b(i,j) == color
                NorthWest(i,j) = 1;                
            else
                max_colum = j-1;
                break;
            end
        end
    end
end    

% North-East-Corner
if b(1,8) == color
    max_colum = 2;           
    for i = 1:7
        for j = 8:-1:max_colum
            if b(i,j) == color
                SouthWest(i,j) = 1;                
            else
                max_colum = j+1;
                break;
            end
        end
    end
end 

% South-East-Corner
if b(8,8) == color
    max_colum = 2;           
    for i = 8:-1:2
        for j = 8:-1:max_colum
            if b(i,j) == color
                SouthEast(i,j) = 1;                
            else
                max_colum = j+1;
                break;
            end
        end
    end
end   

% South-West-Corner
if b(8,1) == color
    max_colum = 7;           
    for i = 8:-1:2
        for j = 1:max_colum
            if b(i,j) == color
                NorthEast(i,j) = 1;                
            else
                max_colum = j-1;
                break;
            end
        end
    end
end

% finally we calculate the value out of all boards defined at the beginning
% of our function
value_of_constant_region = sum(sum(logical(NorthWest+NorthEast+SouthEast+SouthWest)));

end
