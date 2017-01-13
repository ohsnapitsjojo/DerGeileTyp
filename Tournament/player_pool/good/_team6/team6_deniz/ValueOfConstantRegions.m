function value_of_constant_region = ValueOfConstantRegions(b,color)

%% Calculation of all constant regions

% Definition of empty boards
NorthWest = zeros(8,8);
NorthEast = zeros(8,8);
SouthWest = zeros(8,8);
SouthEast = zeros(8,8);

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

% Summarize all boards
value_of_constant_region = sum(sum(logical(NorthWest+NorthEast+SouthEast+SouthWest)));

end
