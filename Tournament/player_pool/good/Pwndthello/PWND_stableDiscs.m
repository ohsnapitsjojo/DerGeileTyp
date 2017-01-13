% Heuristic function to determine the most common stable discs during the
% game. It does not determine all stable discs due to performance issues.

function score = PWND_stableDiscs(b, color)

%initialize empty boards
boardL1 = zeros(8,8);
boardL2 = zeros(8,8);
boardR1 = zeros(8,8);
boardR2 = zeros(8,8);

% search in upper left corner
if b(1,1) == color
    maxj = 7;           % horizontal search
    for i = 1:7
        for j = 1:maxj
            if b(i,j) == color
                boardL1(i,j) = 1;                
            else
                maxj = j-1;
                break;
            end
        end
    end
    maxi = 7;           % vertical search
    for j = 1:7
        for i = 1:maxi
            if b(i,j) == color
                boardL1(i,j) = 1;                
            else
                maxi = i-1;
                break;
            end
        end
    end
end    

% search in upper right corner
if b(1,8) == color
    maxj = 2;           % horizontal search
    for i = 1:7
        for j = 8:-1:maxj
            if b(i,j) == color
                boardR1(i,j) = 1;                
            else
                maxj = j+1;
                break;
            end
        end
    end
    maxi = 7;           % vertical search
    for j = 8:-1:2
        for i = 1:maxi
            if b(i,j) == color
                boardR1(i,j) = 1;                
            else
                maxi = i-1;
                break;
            end
        end
    end
end 

% search in lower left corner
if b(8,1) == color
    maxj = 7;           % horizontal search
    for i = 8:-1:2
        for j = 1:maxj
            if b(i,j) == color
                boardL2(i,j) = 1;                
            else
                maxj = j-1;
                break;
            end
        end
    end
    maxi = 2;           % vertical search
    for j = 1:7
        for i = 8:-1:maxi
            if b(i,j) == color
                boardL2(i,j) = 1;                
            else
                maxi = i+1;
                break;
            end
        end
    end
end 

% search in lower left corner
if b(8,8) == color
    maxj = 2;           % horizontal search
    for i = 8:-1:2
        for j = 8:-1:maxj
            if b(i,j) == color
                boardL2(i,j) = 1;                
            else
                maxj = j+1;
                break;
            end
        end
    end
    maxi = 2;           % vertical search
    for j = 8:-1:2
        for i = 8:-1:maxi
            if b(i,j) == color
                boardL2(i,j) = 1;                
            else
                maxi = i+1;
                break;
            end
        end
    end
end
    
    
board = boardL1 | boardL2 | boardR1 | boardR2;  % combine the results
score = sum(sum(board));                        % count stable stones
