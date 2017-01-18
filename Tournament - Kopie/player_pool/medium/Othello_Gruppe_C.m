% Members of group C:
%
% Martin Medler, Christopher Bayer, Christian Spies, Yao, Ling, Zhanchao
%
%
% workin principle of player:
%
% We use the Minimax Algorithm to search for the best move for the player.
% To speed up the Minimax Algorithm we use the Alpha-Beta Pruning to cut
% off parts of the search tree.
%
% The main function decide whether to search for possible moves via places
% which are empty, or places with own tokens
%
% Then it searches for every possible move the player can do and calls the
% Minimization Function for every move, which will find every possible move
% the enmy can do in response to my move. Then the Minimization Function 
% call the Maximization Function to find every move i can do to answer the 
% enemys move and so on.
% These rekursive function calls build up a search tree. Not every part of
% the tree is explored due to the cutoffs from the alpha beta search.
%
% In the end the move with the highest profit is chosen.
%
%
% Due to the big redundancy between many code parts, only the code
% corresponding to the search via tokens is commented in detail.


%#ok<*ASGLU>                                                                % ignore "MaxV value might be unused"

function Grid = Othello_Gruppe_C(Grid, color, time)
% The main function of the program. It builds up a sreach tree and analyzes
% this tree to determine the move with the biggest profit for the player.
%
% It returns the changed playing field.
%
% Grid      :=  8x8 matrix representing the playing field (1=white, -1=black, 0=empty)
% color     :=  color of the player (1=white, -1=black)
% time      :=  time left to complete the whole game (seconds)

timeID = tic;                                                               % timer handle from timer to monitor runtime of program
maxTime = 20;                                                               % maximal allowed runtime for program (seconds)

alpha = -Inf;                                                               % initialize alpha
beta = Inf;                                                                 % initialize beta
gameState = sum(sum(Grid == 0));                                            % determine the progress of the game by counting the zeros (empty places)

if gameState > 50
    searchDepth = 5;                                                            % depth of the search tree
else
    searchDepth = 6;                                                            % depth of the search tree
end


if time < 21                                                                % chck if the program is running out of time and adapt search depth
    if time < 10
        maxTime = 2;
        searchDepth = 2;                                                    % change to 2, if change of funktion call is succesfull
    else
        maxTime = 9;
        searchDepth = 4;
    end
end

if gameState > 34                                                           % if there are many zeros in the grid, then use Tokens to search for best moves
    
    %%%%     search for possible moves
    
    Moves = zeros(8,8,9);                                                       % allocate "Moves" matrix
    enemy = -color;                                                             % define enemy color
    [potR potC] = find(Grid == color);                                          % search for own tokens
    
    for k = 1:size(potR,1)                                                      % iterate over all own tokens
        
        r = potR(k);                                                            % row of token
        c = potC(k);                                                            % column of token
        
        % top left
        row = r-1;                                                              % adjust row accordingly to the direction
        col = c-1;                                                              % adjust column accordingly to the direction
        if row > 0 && col > 0 && Grid(row,col) == enemy                         % search for adjacent enemy token and check if values are within the playing field boundaries
            for s = 2:7                                                         % search for emtpy field behind enemy tokens
                tRow = r - s;                                                   % adjust row accordingly to the direction
                tCol = c - s;                                                   % adjust column accordingly to the direction
                if tRow > 0 && tCol > 0                                         % check if values are within the playing field boundaries
                    if Grid(tRow, tCol) == 0                                    % found empty field -> valid move
                        Moves(tRow, tCol, 1) = Moves(tRow, tCol, 1) + s-1;      % remember how many tokens can be turned in total from this position
                        Moves(tRow, tCol, 9) = s-1;                             % remember how many tokens to turn in this direction
                        break
                    elseif Grid(tRow, tCol) == color                            % found own token -> no valid move
                        break
                    end
                else                                                            % out of field boundary -> no valid move
                    break
                end
            end
        end
        
        % left
        col = c-1;
        if col > 0 && Grid(r,col) == enemy
            for s = c-2:-1:1                                                    % use loop as colum coordinate, so no check for boundary is necessary
                if Grid(r, s) == 0                                              % valid move
                    Moves(r, s, 1) = Moves(r, s, 1) + c-s-1;
                    Moves(r, s, 8) = c-s-1;
                    break
                elseif Grid(r, s) == color                                      % no valid move
                    break
                end
            end
        end
        
        % bottom left
        row = r+1;
        col = c-1;
        if row < 9 && col > 0 && Grid(row,col) == enemy
            for s = 2:7
                tRow = r + s;
                tCol = c - s;
                if tRow < 9 && tCol > 0
                    if Grid(tRow, tCol) == 0                                    % valid move
                        Moves(tRow, tCol, 1) = Moves(tRow, tCol, 1) + s-1;
                        Moves(tRow, tCol, 7) = s-1;
                        break
                    elseif Grid(tRow, tCol) == color                            % no valid move
                        break
                    end
                else                                                            % out of boundary
                    break
                end
            end
        end
        
        % top
        row = r-1;
        if row > 0 && Grid(row,c) == enemy
            for s = r-2:-1:1
                if Grid(s, c) == 0                                              % valid move
                    Moves(s, c, 1) = Moves(s, c, 1) + r-s-1;
                    Moves(s, c, 6) = r-s-1;
                    break
                elseif Grid(s, c) == color                                      % no valid move
                    break
                end
            end
        end
        
        % bottom
        row = r+1;
        if row < 9 && Grid(row,c) == enemy
            for s = r+2:8
                if Grid(s, c) == 0                                              % valid move
                    Moves(s, c, 1) = Moves(s, c, 1) + s-r-1;
                    Moves(s, c, 5) = s-r-1;
                    break
                elseif Grid(s, c) == color                                      % no valid move
                    break
                end
            end
        end
        
        % top right
        row = r-1;
        col = c+1;
        if row > 0 && col < 9 && Grid(row,col) == enemy
            for s = 2:7
                tRow = r - s;
                tCol = c + s;
                if tRow > 0 && tCol < 9
                    if Grid(tRow, tCol) == 0                                    % valid move
                        Moves(tRow, tCol, 1) = Moves(tRow, tCol, 1) + s-1;
                        Moves(tRow, tCol, 4) = s-1;
                        break
                    elseif Grid(tRow, tCol) == color                            % no valid move
                        break
                    end
                else                                                            % out of boundary
                    break
                end
            end
        end
        
        % right
        col = c+1;
        if col < 9 && Grid(r,col) == enemy
            for s = c+2:8
                if Grid(r, s) == 0                                              % valid move
                    Moves(r, s, 1) = Moves(r, s, 1) + s-c-1;
                    Moves(r, s, 3) = s-c-1;
                    break
                elseif Grid(r, s) == color                                      % no valid move
                    break
                end
            end
        end
        
        % bottom right
        row = r+1;
        col = c+1;
        if row < 9 && col < 9 && Grid(row,col) == enemy
            for s = 2:7
                tRow = r + s;
                tCol = c + s;
                if tRow < 9 && tCol < 9
                    if Grid(tRow, tCol) == 0                                    % valid move
                        Moves(tRow, tCol, 1) = Moves(tRow, tCol, 1) + s-1;
                        Moves(tRow, tCol, 2) = s-1;
                        break
                    elseif Grid(tRow, tCol) == color                            % no valid move
                        break
                    end
                else                                                            % out of boundary
                    break
                end
            end
        end
        
    end
    
    possMov = find(Moves(:,:,1) > 0);                                       % extract possible moves out of the "Moves" matrix
    numbM =  size(possMov,1);                                               % number of possible moves
    
    if numbM < 1                                                            % check if moves possible, no moves -> skip turn
        return
    end
    
    valueM = zeros(numbM, 1);                                               % allocate vector to remember the profit from the possible moves
    
    for p = 1:numbM                                                         % iterate over all possible moves
        tempGrid = Grid;                                                    % copy the current grid into the temporary grid
        
        %%%%       change the temporary grid accordingly to one possible move
        
        x = floor( (possMov(p)-1)/8 +1 );                                                  % determine column of the origin token of the move
        y = mod( (possMov(p)-1), 8 ) + 1;                                                  % determine row of the origin token of the move
        tempGrid(y,x) = color;                                                          % place origin token of the move
        
        % top left
        for s = 1:Moves(y, x, 2)                                                    % turn x enemy tokens accrodingly to the chosen move
            tempGrid(y-s, x-s) = color;                                                 % turn enemy tokens
        end
        % left
        for s = 1:Moves(y, x, 3)
            tempGrid(y , x-s) = color;
        end
        % bottom left
        for s = 1:Moves(y, x, 4)
            tempGrid(y+s , x-s) = color;
        end
        % top
        for s = 1:Moves(y, x, 5)
            tempGrid(y-s , x) = color;
        end
        % bottom
        for s = 1:Moves(y, x, 6)
            tempGrid(y+s , x) = color;
        end
        % top right
        for s = 1:Moves(y, x, 7)
            tempGrid(y-s , x+s) = color;
        end
        % right
        for s = 1:Moves(y, x, 8)
            tempGrid(y , x+s) = color;
        end
        % bottom right
        for s = 1:Moves(y, x, 9)
            tempGrid(y+s , x+s) = color;
        end

        valueM(p) = MinTokens(tempGrid, searchDepth, ...                    % expand search tree for this move
            alpha, beta, color, timeID, maxTime);
        if valueM(p) > alpha                                                % check if profit is bigger then the alpha value
            alpha = valueM(p);                                              % update the alpha value
        end
        
    end
    
    [MaxV, mInd] = max(valueM);                                             % find the move with the biggest profit
    
    %%%%    change the grid accordingly to the move with the biggest profit
    
    x = floor( (possMov(mInd)-1)/8 +1 );                                                  % determine column of the origin token of the move
    y = mod( (possMov(mInd)-1), 8 ) + 1;                                                  % determine row of the origin token of the move
    Grid(y,x) = color;                                                          % place origin token of the move
    
    % top left
    for s = 1:Moves(y, x, 2)                                                    % turn x enemy tokens accrodingly to the chosen move
        Grid(y-s, x-s) = color;                                                 % turn enemy tokens
    end
    % left
    for s = 1:Moves(y, x, 3)
        Grid(y , x-s) = color;
    end
    % bottom left
    for s = 1:Moves(y, x, 4)
        Grid(y+s , x-s) = color;
    end
    % top
    for s = 1:Moves(y, x, 5)
        Grid(y-s , x) = color;
    end
    % bottom
    for s = 1:Moves(y, x, 6)
        Grid(y+s , x) = color;
    end
    % top right
    for s = 1:Moves(y, x, 7)
        Grid(y-s , x+s) = color;
    end
    % right
    for s = 1:Moves(y, x, 8)
        Grid(y , x+s) = color;
    end
    % bottom right
    for s = 1:Moves(y, x, 9)
        Grid(y+s , x+s) = color;
    end
    
else                                                                        % if there are only a few zeros in the grid, then use these to search for best moves
    %%%%    search for possible moves
    
    Moves = zeros(25,10);
    count = 0;
    enemy = -color;
    [potR potC] = find(Grid == 0);                                              % search for empty places
    
    for k = 1:size(potR,1)                                                      % iterate over all empty places
        
        r = potR(k);                                                            % row of token
        c = potC(k);                                                            % column of token
        solC = 0;
        
        % top left
        row = r-1;
        col = c-1;
        if row > 0 && col > 0 && Grid(row,col) == enemy                         % search for adjacent enemy token
            for s = 2:7                                                         % search for own token behind enemy tokens
                tRow = r - s;
                tCol = c - s;
                if tRow > 0 && tCol > 0
                    if Grid(tRow, tCol) == color                                % found own token -> valid move
                        solC = solC + 1;
                        if solC < 2
                            count = count + 1;
                            Moves(count, 2) = (c-1)*8+r;
                        end
                        Moves(count, 1) = Moves(count, 1) + s-1;                % remember how many tokens can be turned from this position
                        Moves(count, 3) = s-1;                                  % remember how many tokens to turn in this direction
                        break
                    elseif Grid(tRow, tCol) == 0                                % found empty place -> no valid move
                        break
                    end
                else                                                            % out of field boundary -> no valid move
                    break
                end
            end
        end
        
        % left
        col = c-1;
        if col > 0 && Grid(r,col) == enemy
            for s = c-2:-1:1                                                    % use loop as colum coordinate, so no check for boundary is necessary
                if Grid(r, s) == color                                          % valid move
                    solC = solC + 1;
                    if solC < 2
                        count = count + 1;
                        Moves(count, 2) = (c-1)*8+r;
                    end
                    Moves(count, 1) = Moves(count, 1) + c-s-1;
                    Moves(count, 4) = c-s-1;
                    break
                elseif Grid(r, s) == 0                                          % no valid move
                    break
                end
            end
        end
        
        % bottom left
        row = r+1;
        col = c-1;
        if row < 9 && col > 0 && Grid(row,col) == enemy
            for s = 2:7
                tRow = r + s;
                tCol = c - s;
                if tRow < 9 && tCol > 0
                    if Grid(tRow, tCol) == color                                % valid move
                        solC = solC + 1;
                        if solC < 2
                            count = count + 1;
                            Moves(count, 2) = (c-1)*8+r;
                        end
                        Moves(count, 1) = Moves(count, 1) + s-1;
                        Moves(count, 5) = s-1;
                        break
                    elseif Grid(tRow, tCol) == 0                                % no valid move
                        break
                    end
                else                                                            % out of boundary
                    break
                end
            end
        end
        
        % top
        row = r-1;
        if row > 0 && Grid(row,c) == enemy
            for s = r-2:-1:1
                if Grid(s, c) == color                                          % valid move
                    solC = solC + 1;
                    if solC < 2
                        count = count + 1;
                        Moves(count, 2) = (c-1)*8+r;
                    end
                    Moves(count, 1) = Moves(count, 1) + r-s-1;
                    Moves(count, 6) = r-s-1;
                    break
                elseif Grid(s, c) == 0                                          % no valid move
                    break
                end
            end
        end
        
        % bottom
        row = r+1;
        if row < 9 && Grid(row,c) == enemy
            for s = r+2:8
                if Grid(s, c) == color                                          % valid move
                    solC = solC + 1;
                    if solC < 2
                        count = count + 1;
                        Moves(count, 2) = (c-1)*8+r;
                    end
                    Moves(count, 1) = Moves(count, 1) + s-r-1;
                    Moves(count, 7) = s-r-1;
                    break
                elseif Grid(s, c) == 0                                          % no valid move
                    break
                end
            end
        end
        
        % top right
        row = r-1;
        col = c+1;
        if row > 0 && col < 9 && Grid(row,col) == enemy
            for s = 2:7
                tRow = r - s;
                tCol = c + s;
                if tRow > 0 && tCol < 9
                    if Grid(tRow, tCol) == color                                % valid move
                        solC = solC + 1;
                        if solC < 2
                            count = count + 1;
                            Moves(count, 2) = (c-1)*8+r;
                        end
                        Moves(count, 1) = Moves(count, 1) + s-1;
                        Moves(count, 8) = s-1;
                        break
                    elseif Grid(tRow, tCol) == 0                                % no valid move
                        break
                    end
                else                                                            % out of boundary
                    break
                end
            end
        end
        
        % right
        col = c+1;
        if col < 9 && Grid(r,col) == enemy
            for s = c+2:8
                if Grid(r, s) == color                                          % valid move
                    solC = solC + 1;
                    if solC < 2
                        count = count + 1;
                        Moves(count, 2) = (c-1)*8+r;
                    end
                    Moves(count, 1) = Moves(count, 1) + s-c-1;
                    Moves(count, 9) = s-c-1;
                    break
                elseif Grid(r, s) == 0                                          % no valid move
                    break
                end
            end
        end
        
        % bottom right
        row = r+1;
        col = c+1;
        if row < 9 && col < 9 && Grid(row,col) == enemy
            for s = 2:7
                tRow = r + s;
                tCol = c + s;
                if tRow < 9 && tCol < 9
                    if Grid(tRow, tCol) == color                                % valid move
                        solC = solC + 1;
                        if solC < 2
                            count = count + 1;
                            Moves(count, 2) = (c-1)*8+r;
                        end
                        Moves(count, 1) = Moves(count, 1) + s-1;
                        Moves(count, 10) = s-1;
                        break
                    elseif Grid(tRow, tCol) == 0                                % no valid move
                        break
                    end
                else                                                            % out of boundary
                    break
                end
            end
        end
        
    end
    
    possMov = find(Moves(:,2) > 0);                                         % extract possible moves out of the "Moves" matrix
    numbM =  size(possMov,1);                                               % number of possible moves
    
    if numbM < 1                                                            % check if moves possible, no moves -> skip turn
        return
    end
    
    valueM = zeros(numbM, 1);                                               % allocate vector to remember the profit from the possible moves
    
    for p = 1:numbM
        tempGrid = Grid;                                                    % copy the current grid into the temporary grid
        
        %%%%     change the temporary grid accordingly to one possible move
        
        Ind = possMov(p);
        x = floor( (Moves(Ind,2)-1)/8 +1 );
        y = mod( (Moves(Ind,2)-1), 8 ) + 1;        
        tempGrid(y,x) = color;                                                          % place origin token of the move
        
        % top lef
        for s = 1:Moves(Ind, 3)                                                     % turn enemy tokens accrodingly to the chosen move
            tempGrid(y-s, x-s) = color;
        end
        % left
        for s = 1:Moves(Ind, 4)
            tempGrid(y , x-s) = color;
        end
        % bottom left
        for s = 1:Moves(Ind, 5)
            tempGrid(y+s , x-s) = color;
        end
        % top
        for s = 1:Moves(Ind, 6)
            tempGrid(y-s , x) = color;
        end
        % bottom
        for s = 1:Moves(Ind, 7)
            tempGrid(y+s , x) = color;
        end
        % top right
        for s = 1:Moves(Ind, 8)
            tempGrid(y-s , x+s) = color;
        end
        % right
        for s = 1:Moves(Ind, 9)
            tempGrid(y , x+s) = color;
        end
        % bottom right
        for s = 1:Moves(Ind, 10)
            tempGrid(y+s , x+s) = color;
        end
        
        valueM(p) = MinZeros(tempGrid, searchDepth, ...                     % expand search tree for this move
            alpha, beta, color, timeID, maxTime);
        if valueM(p) > alpha                                                % check if profit is bigger then the alpha value
            alpha = valueM(p);                                              % update the alpha value
        end
        
    end
    
    [MaxV, mInd] = max(valueM);                                             % find the move with the biggest profit
    
    %%%%     change the grid accordingly to the move with the biggest profit
    
    Ind = possMov(mInd);
    x = floor( (Moves(Ind,2)-1)/8 +1 );
    y = mod( (Moves(Ind,2)-1), 8 ) + 1;    
    Grid(y,x) = color;                                                          % place origin token of the move
    
    % top lef
    for s = 1:Moves(Ind, 3)                                                     % turn enemy tokens accrodingly to the chosen move
        Grid(y-s, x-s) = color;
    end    
    % left
    for s = 1:Moves(Ind, 4)
        Grid(y , x-s) = color;
    end    
    % bottom left
    for s = 1:Moves(Ind, 5)
        Grid(y+s , x-s) = color;
    end    
    % top
    for s = 1:Moves(Ind, 6)
        Grid(y-s , x) = color;
    end    
    % bottom
    for s = 1:Moves(Ind, 7)
        Grid(y+s , x) = color;
    end    
    % top right
    for s = 1:Moves(Ind, 8)
        Grid(y-s , x+s) = color;
    end    
    % right
    for s = 1:Moves(Ind, 9)
        Grid(y , x+s) = color;
    end    
    % bottom right
    for s = 1:Moves(Ind, 10)
        Grid(y+s , x+s) = color;
    end    
    
end

end


function profit = MaxTokens(Grid, step, alpha, beta, mycolor, timeID, maxTime)
% This function builds a part of the search tree (one of the players turns). To find
% the best move it analyzes the tree by maximizing the outcome for the player.
%
% It returns the exptected profit corresponding to the move which was used
% to call this function (the Grid)
%
% Grid      :=  8x8 matrix representing the playing field
% step      :=  counter tracking the depth of the search tree (0 = leafs)
% alpha     :=  alpha value for the alpha-beta pruning
% beta      :=  beta value for the alpha-beta pruning
% mycolor   :=  color of the player
% timeID    :=  handle of the timer monitoring the program runtime
% maxTime   :=  maximal allowed runtime for the program


if toc(timeID) > maxTime                                                    % check if maximal allowed runtime has been exceeded
    profit = -Inf;                                                          % assign a profit which will cause a guaranteed cutoff in the higher layer of the search tree
    return                                                                  % end the function and stop building the search tree
end

%%%%     search for possible moves for the current status of the playing field in the search tree

Moves = zeros(8,8,9);                                                       % allocate "Moves" matrix
color = mycolor;
enemy = -color;                                                             % define enemy color
[potR potC] = find(Grid == color);                                          % search for own tokens

for k = 1:size(potR,1)                                                      % iterate over all own tokens
    
    r = potR(k);                                                            % row of token
    c = potC(k);                                                            % column of token
    
    % top left
    row = r-1;                                                              % adjust row accordingly to the direction
    col = c-1;                                                              % adjust column accordingly to the direction
    if row > 0 && col > 0 && Grid(row,col) == enemy                         % search for adjacent enemy token and check if values are within the playing field boundaries
        for s = 2:7                                                         % search for emtpy field behind enemy tokens
            tRow = r - s;                                                   % adjust row accordingly to the direction
            tCol = c - s;                                                   % adjust column accordingly to the direction
            if tRow > 0 && tCol > 0                                         % check if values are within the playing field boundaries
                if Grid(tRow, tCol) == 0                                    % found empty field -> valid move
                    Moves(tRow, tCol, 1) = Moves(tRow, tCol, 1) + s-1;      % remember how many tokens can be turned in total from this position
                    Moves(tRow, tCol, 9) = s-1;                             % remember how many tokens to turn in this direction
                    break
                elseif Grid(tRow, tCol) == color                            % found own token -> no valid move
                    break
                end
            else                                                            % out of field boundary -> no valid move
                break
            end
        end
    end
    
    % left
    col = c-1;
    if col > 0 && Grid(r,col) == enemy
        for s = c-2:-1:1                                                    % use loop as colum coordinate, so no check for boundary is necessary
            if Grid(r, s) == 0                                              % valid move
                Moves(r, s, 1) = Moves(r, s, 1) + c-s-1;
                Moves(r, s, 8) = c-s-1;
                break
            elseif Grid(r, s) == color                                      % no valid move
                break
            end
        end
    end
    
    % bottom left
    row = r+1;
    col = c-1;
    if row < 9 && col > 0 && Grid(row,col) == enemy
        for s = 2:7
            tRow = r + s;
            tCol = c - s;
            if tRow < 9 && tCol > 0
                if Grid(tRow, tCol) == 0                                    % valid move
                    Moves(tRow, tCol, 1) = Moves(tRow, tCol, 1) + s-1;
                    Moves(tRow, tCol, 7) = s-1;
                    break
                elseif Grid(tRow, tCol) == color                            % no valid move
                    break
                end
            else                                                            % out of boundary
                break
            end
        end
    end
    
    % top
    row = r-1;
    if row > 0 && Grid(row,c) == enemy
        for s = r-2:-1:1
            if Grid(s, c) == 0                                              % valid move
                Moves(s, c, 1) = Moves(s, c, 1) + r-s-1;
                Moves(s, c, 6) = r-s-1;
                break
            elseif Grid(s, c) == color                                      % no valid move
                break
            end
        end
    end
    
    % bottom
    row = r+1;
    if row < 9 && Grid(row,c) == enemy
        for s = r+2:8
            if Grid(s, c) == 0                                              % valid move
                Moves(s, c, 1) = Moves(s, c, 1) + s-r-1;
                Moves(s, c, 5) = s-r-1;
                break
            elseif Grid(s, c) == color                                      % no valid move
                break
            end
        end
    end
    
    % top right
    row = r-1;
    col = c+1;
    if row > 0 && col < 9 && Grid(row,col) == enemy
        for s = 2:7
            tRow = r - s;
            tCol = c + s;
            if tRow > 0 && tCol < 9
                if Grid(tRow, tCol) == 0                                    % valid move
                    Moves(tRow, tCol, 1) = Moves(tRow, tCol, 1) + s-1;
                    Moves(tRow, tCol, 4) = s-1;
                    break
                elseif Grid(tRow, tCol) == color                            % no valid move
                    break
                end
            else                                                            % out of boundary
                break
            end
        end
    end
    
    % right
    col = c+1;
    if col < 9 && Grid(r,col) == enemy
        for s = c+2:8
            if Grid(r, s) == 0                                              % valid move
                Moves(r, s, 1) = Moves(r, s, 1) + s-c-1;
                Moves(r, s, 3) = s-c-1;
                break
            elseif Grid(r, s) == color                                      % no valid move
                break
            end
        end
    end
    
    % bottom right
    row = r+1;
    col = c+1;
    if row < 9 && col < 9 && Grid(row,col) == enemy
        for s = 2:7
            tRow = r + s;
            tCol = c + s;
            if tRow < 9 && tCol < 9
                if Grid(tRow, tCol) == 0                                    % valid move
                    Moves(tRow, tCol, 1) = Moves(tRow, tCol, 1) + s-1;
                    Moves(tRow, tCol, 2) = s-1;
                    break
                elseif Grid(tRow, tCol) == color                            % no valid move
                    break
                end
            else                                                            % out of boundary
                break
            end
        end
    end
    
end

possMov = find(Moves(:,:,1) > 0);                                           % search for the possible moves contained in the 8x8 matrix "Moves"
numbM =  size(possMov,1);                                                   % get number of possible moves

if step < 2                                                                 % check if the second last part of the tree has been reached
    
    if numbM < 1                                                            % check if player can do a move
%         profit = mycolor*EvaluateGrid(Grid, mycolor);                                % evaluate the playing field and return the corresponding profit
        profit = EvaluateGrid(Grid, mycolor);                                % evaluate the playing field and return the corresponding profit
        return
    end
    
    for p = 1:numbM                                                         % iterate over every possible move and extend the search tree with this move
        tempGrid = Grid;                                                    % copy the grid into the temporary grid

%%%%     change the temporary grid accordingly to one possible move        
        
        x = floor( (possMov(p)-1)/8 +1 );                                                  % determine column of the origin token of the move
        y = mod( (possMov(p)-1), 8 ) + 1;                                                  % determine row of the origin token of the move        
        tempGrid(y,x) = color;                                                          % place origin token of the move
        
        % top left
        for s = 1:Moves(y, x, 2)                                                    % turn x enemy tokens accrodingly to the chosen move
            tempGrid(y-s, x-s) = color;                                                 % turn enemy tokens
        end
        % left
        for s = 1:Moves(y, x, 3)
            tempGrid(y , x-s) = color;
        end
        % bottom left
        for s = 1:Moves(y, x, 4)
            tempGrid(y+s , x-s) = color;
        end
        % top
        for s = 1:Moves(y, x, 5)
            tempGrid(y-s , x) = color;
        end
        % bottom
        for s = 1:Moves(y, x, 6)
            tempGrid(y+s , x) = color;
        end
        % top right
        for s = 1:Moves(y, x, 7)
            tempGrid(y-s , x+s) = color;
        end
        % right
        for s = 1:Moves(y, x, 8)
            tempGrid(y , x+s) = color;
        end
        % bottom right
        for s = 1:Moves(y, x, 9)
            tempGrid(y+s , x+s) = color;
        end
        
%         temp = mycolor*EvaluateGrid(tempGrid, mycolor);                              % evaluate the temp. grid
        temp = EvaluateGrid(tempGrid, mycolor);                              % evaluate the temp. grid
        if temp >= beta                                                     % detect a cutoff
            profit = temp;                                                  % assign the profit gained in this part of the search tree
            return                                                          % end the function and search no longer in this part of the search tree
        end
        if temp > alpha                                                     % check if the profit of this move is better as the current alpha value
            alpha = temp;                                                   % update the alpha value
        end
    end
    
    profit = alpha;                                                         % return alpha as profit
    return
end

if numbM < 1                                                                % check if player can do a move
    profit = MinTokens( Grid, step-1, alpha, beta, ...                      % return the profit without comparing to alpha, because the player has no choice
        mycolor, timeID, maxTime);
    return
end

for p = 1:numbM                                                             % iterate over every possible move and extend the search tree with this move
    tempGrid = Grid;                                                        % copy the grid into the temporary grid

 %%%%    change the temporary grid accordingly to one possible move    
    
    x = floor( (possMov(p)-1)/8 +1 );                                                  % determine column of the origin token of the move
    y = mod( (possMov(p)-1), 8 ) + 1;                                                  % determine row of the origin token of the move    
    tempGrid(y,x) = color;                                                          % place origin token of the move
    
    % top left
    for s = 1:Moves(y, x, 2)                                                    % turn x enemy tokens accrodingly to the chosen move
        tempGrid(y-s, x-s) = color;                                                 % turn enemy tokens
    end
    % left
    for s = 1:Moves(y, x, 3)
        tempGrid(y , x-s) = color;
    end
    % bottom left
    for s = 1:Moves(y, x, 4)
        tempGrid(y+s , x-s) = color;
    end
    % top
    for s = 1:Moves(y, x, 5)
        tempGrid(y-s , x) = color;
    end
    % bottom
    for s = 1:Moves(y, x, 6)
        tempGrid(y+s , x) = color;
    end
    % top right
    for s = 1:Moves(y, x, 7)
        tempGrid(y-s , x+s) = color;
    end
    % right
    for s = 1:Moves(y, x, 8)
        tempGrid(y , x+s) = color;
    end
    % bottom right
    for s = 1:Moves(y, x, 9)
        tempGrid(y+s , x+s) = color;
    end

    temp = MinTokens( tempGrid, step-1, alpha, beta, ...                    % use the temp. grid to extend the search tree accordingly to the move represented by the temp. grid
        mycolor, timeID, maxTime);
    if temp >= beta                                                         % detect a cutoff
        profit = temp;                                                      % assign the profit gained in this part of the search tree
        return                                                              % end the function and search no longer in this part of the search tree
    end
    if temp > alpha                                                         % check if the profit of thisd move is better as the current alpha value
        alpha = temp;                                                       % update the alpha value
    end
end

profit = alpha;                                                             % assign the alpha value as profit
end

function profit = MaxZeros(Grid, step, alpha, beta, mycolor, timeID, maxTime)
% This function builds a part of the search tree (one of the players turns). To find
% the best move it analyzes the tree by maximizing the outcome for the player.
%
% It returns the exptected profit corresponding to the move which was used
% to call this function (the Grid)
%
% Grid      :=  8x8 matrix representing the playing field
% step      :=  counter tracking the depth of the search tree (0 = leafs)
% alpha     :=  alpha value for the alpha-beta pruning
% beta      :=  beta value for the alpha-beta pruning
% mycolor   :=  color of the player
% timeID    :=  handle of the timer monitoring the program runtime
% maxTime   :=  maximal allowed runtime for the program

if toc(timeID) > maxTime
    profit = -Inf;
    return
end

Moves = zeros(25,10);
count = 0;
color = mycolor;
enemy = -color;
[potR potC] = find(Grid == 0);                                              % search for empty places

for k = 1:size(potR,1)                                                      % iterate over all empty places
    
    r = potR(k);                                                            % row of token
    c = potC(k);                                                            % column of token
    solC = 0;
    
    % top left
    row = r-1;
    col = c-1;
    if row > 0 && col > 0 && Grid(row,col) == enemy                         % search for adjacent enemy token
        for s = 2:7                                                         % search for own token behind enemy tokens
            tRow = r - s;
            tCol = c - s;
            if tRow > 0 && tCol > 0
                if Grid(tRow, tCol) == color                                % found own token -> valid move
                    solC = solC + 1;
                    if solC < 2
                        count = count + 1;
                        Moves(count, 2) = (c-1)*8+r;
                    end
                    Moves(count, 1) = Moves(count, 1) + s-1;                % remember how many tokens can be turned from this position
                    Moves(count, 3) = s-1;                                  % remember how many tokens to turn in this direction
                    break
                elseif Grid(tRow, tCol) == 0                                % found empty place -> no valid move
                    break
                end
            else                                                            % out of field boundary -> no valid move
                break
            end
        end
    end
    
    % left
    col = c-1;
    if col > 0 && Grid(r,col) == enemy
        for s = c-2:-1:1                                                    % use loop as colum coordinate, so no check for boundary is necessary
            if Grid(r, s) == color                                          % valid move
                solC = solC + 1;
                if solC < 2
                    count = count + 1;
                    Moves(count, 2) = (c-1)*8+r;
                end
                Moves(count, 1) = Moves(count, 1) + c-s-1;
                Moves(count, 4) = c-s-1;
                break
            elseif Grid(r, s) == 0                                          % no valid move
                break
            end
        end
    end
    
    % bottom left
    row = r+1;
    col = c-1;
    if row < 9 && col > 0 && Grid(row,col) == enemy
        for s = 2:7
            tRow = r + s;
            tCol = c - s;
            if tRow < 9 && tCol > 0
                if Grid(tRow, tCol) == color                                % valid move
                    solC = solC + 1;
                    if solC < 2
                        count = count + 1;
                        Moves(count, 2) = (c-1)*8+r;
                    end
                    Moves(count, 1) = Moves(count, 1) + s-1;
                    Moves(count, 5) = s-1;
                    break
                elseif Grid(tRow, tCol) == 0                                % no valid move
                    break
                end
            else                                                            % out of boundary
                break
            end
        end
    end
    
    % top
    row = r-1;
    if row > 0 && Grid(row,c) == enemy
        for s = r-2:-1:1
            if Grid(s, c) == color                                          % valid move
                solC = solC + 1;
                if solC < 2
                    count = count + 1;
                    Moves(count, 2) = (c-1)*8+r;
                end
                Moves(count, 1) = Moves(count, 1) + r-s-1;
                Moves(count, 6) = r-s-1;
                break
            elseif Grid(s, c) == 0                                          % no valid move
                break
            end
        end
    end
    
    % bottom
    row = r+1;
    if row < 9 && Grid(row,c) == enemy
        for s = r+2:8
            if Grid(s, c) == color                                          % valid move
                solC = solC + 1;
                if solC < 2
                    count = count + 1;
                    Moves(count, 2) = (c-1)*8+r;
                end
                Moves(count, 1) = Moves(count, 1) + s-r-1;
                Moves(count, 7) = s-r-1;
                break
            elseif Grid(s, c) == 0                                          % no valid move
                break
            end
        end
    end
    
    % top right
    row = r-1;
    col = c+1;
    if row > 0 && col < 9 && Grid(row,col) == enemy
        for s = 2:7
            tRow = r - s;
            tCol = c + s;
            if tRow > 0 && tCol < 9
                if Grid(tRow, tCol) == color                                % valid move
                    solC = solC + 1;
                    if solC < 2
                        count = count + 1;
                        Moves(count, 2) = (c-1)*8+r;
                    end
                    Moves(count, 1) = Moves(count, 1) + s-1;
                    Moves(count, 8) = s-1;
                    break
                elseif Grid(tRow, tCol) == 0                                % no valid move
                    break
                end
            else                                                            % out of boundary
                break
            end
        end
    end
    
    % right
    col = c+1;
    if col < 9 && Grid(r,col) == enemy
        for s = c+2:8
            if Grid(r, s) == color                                          % valid move
                solC = solC + 1;
                if solC < 2
                    count = count + 1;
                    Moves(count, 2) = (c-1)*8+r;
                end
                Moves(count, 1) = Moves(count, 1) + s-c-1;
                Moves(count, 9) = s-c-1;
                break
            elseif Grid(r, s) == 0                                          % no valid move
                break
            end
        end
    end
    
    % bottom right
    row = r+1;
    col = c+1;
    if row < 9 && col < 9 && Grid(row,col) == enemy
        for s = 2:7
            tRow = r + s;
            tCol = c + s;
            if tRow < 9 && tCol < 9
                if Grid(tRow, tCol) == color                                % valid move
                    solC = solC + 1;
                    if solC < 2
                        count = count + 1;
                        Moves(count, 2) = (c-1)*8+r;
                    end
                    Moves(count, 1) = Moves(count, 1) + s-1;
                    Moves(count, 10) = s-1;
                    break
                elseif Grid(tRow, tCol) == 0                                % no valid move
                    break
                end
            else                                                            % out of boundary
                break
            end
        end
    end
    
end

possMov = find(Moves(:,2) > 0);
numbM =  size(possMov,1);

if step < 2
    
    if numbM < 1
%         profit = mycolor*EvaluateGrid(Grid, mycolor);
        profit = EvaluateGrid(Grid, mycolor);
        return
    end
    
    for p = 1:numbM
        tempGrid = Grid;
        
        Ind = possMov(p);
        x = floor( (Moves(Ind,2)-1)/8 +1 );
        y = mod( (Moves(Ind,2)-1), 8 ) + 1;
        
        tempGrid(y,x) = color;                                                          % place origin token of the move
        
        % top lef
        for s = 1:Moves(Ind, 3)                                                     % turn enemy tokens accrodingly to the chosen move
            tempGrid(y-s, x-s) = color;
        end
        % left
        for s = 1:Moves(Ind, 4)
            tempGrid(y , x-s) = color;
        end
        % bottom left
        for s = 1:Moves(Ind, 5)
            tempGrid(y+s , x-s) = color;
        end
        % top
        for s = 1:Moves(Ind, 6)
            tempGrid(y-s , x) = color;
        end
        % bottom
        for s = 1:Moves(Ind, 7)
            tempGrid(y+s , x) = color;
        end
        % top right
        for s = 1:Moves(Ind, 8)
            tempGrid(y-s , x+s) = color;
        end
        % right
        for s = 1:Moves(Ind, 9)
            tempGrid(y , x+s) = color;
        end
        % bottom right
        for s = 1:Moves(Ind, 10)
            tempGrid(y+s , x+s) = color;
        end
        
%         temp = mycolor*EvaluateGrid(tempGrid, mycolor);
        temp = EvaluateGrid(tempGrid, mycolor);
        if temp >= beta                                                     % cutoff
            profit = temp;
            return
        end
        if temp > alpha
            alpha = temp;
        end
    end
    
    profit = alpha;
    return
end

if numbM < 1
    temp = MinZeros( Grid, step-1, alpha, beta, mycolor, timeID, maxTime);
    profit = temp;
    return
end

for p = 1:numbM
    tempGrid = Grid;
    
    Ind = possMov(p);
    x = floor( (Moves(Ind,2)-1)/8 +1 );
    y = mod( (Moves(Ind,2)-1), 8 ) + 1;    
    tempGrid(y,x) = color;                                                          % place origin token of the move
    
    % top lef
    for s = 1:Moves(Ind, 3)                                                     % turn enemy tokens accrodingly to the chosen move
        tempGrid(y-s, x-s) = color;
    end
    % left
    for s = 1:Moves(Ind, 4)
        tempGrid(y , x-s) = color;
    end
    % bottom left
    for s = 1:Moves(Ind, 5)
        tempGrid(y+s , x-s) = color;
    end
    % top
    for s = 1:Moves(Ind, 6)
        tempGrid(y-s , x) = color;
    end
    % bottom
    for s = 1:Moves(Ind, 7)
        tempGrid(y+s , x) = color;
    end
    % top right
    for s = 1:Moves(Ind, 8)
        tempGrid(y-s , x+s) = color;
    end
    % right
    for s = 1:Moves(Ind, 9)
        tempGrid(y , x+s) = color;
    end
    % bottom right
    for s = 1:Moves(Ind, 10)
        tempGrid(y+s , x+s) = color;
    end

    temp = MinZeros( tempGrid, step-1, alpha, beta, mycolor, timeID, maxTime);
    if temp >= beta                                                         % cutoff
        profit = temp;
        return
    end
    if temp > alpha
        alpha = temp;
    end
end

profit = alpha;
end

function profit = MinTokens(Grid, step, alpha, beta, mycolor, timeID, maxTime)
% This function builds a part of the search tree (one of the enemys turns). To find
% the best move it analyzes the tree by minimizing the outcome for the player.
%
% It returns the exptected profit corresponding to the move which was used
% to call this function (the Grid)
%
% Grid      :=  8x8 matrix representing the playing field
% step      :=  counter tracking the depth of the search tree (0 = leafs)
% alpha     :=  alpha value for the alpha-beta pruning
% beta      :=  beta value for the alpha-beta pruning
% mycolor   :=  color of the player
% timeID    :=  handle of the timer monitoring the program runtime
% maxTime   :=  maximal allowed runtime for the program

if toc(timeID) > maxTime                                                    % check if maximal allowed runtime has been exceeded
    profit = Inf;                                                           % assign a profit which will cause a guaranteed cutoff in the higher layer of the search tree
    return                                                                  % end the function and stop building the search tree
end

%%%%    search for possible moves for the current status of the playing field in the search tree

Moves = zeros(8,8,9);                                                       % allocate "Moves" matrix
color = -mycolor;
enemy = -color;                                                             % define enemy color
[potR potC] = find(Grid == color);                                          % search for own tokens

for k = 1:size(potR,1)                                                      % iterate over all own tokens
    
    r = potR(k);                                                            % row of token
    c = potC(k);                                                            % column of token
    
    % top left
    row = r-1;                                                              % adjust row accordingly to the direction
    col = c-1;                                                              % adjust column accordingly to the direction
    if row > 0 && col > 0 && Grid(row,col) == enemy                         % search for adjacent enemy token and check if values are within the playing field boundaries
        for s = 2:7                                                         % search for emtpy field behind enemy tokens
            tRow = r - s;                                                   % adjust row accordingly to the direction
            tCol = c - s;                                                   % adjust column accordingly to the direction
            if tRow > 0 && tCol > 0                                         % check if values are within the playing field boundaries
                if Grid(tRow, tCol) == 0                                    % found empty field -> valid move
                    Moves(tRow, tCol, 1) = Moves(tRow, tCol, 1) + s-1;      % remember how many tokens can be turned in total from this position
                    Moves(tRow, tCol, 9) = s-1;                             % remember how many tokens to turn in this direction
                    break
                elseif Grid(tRow, tCol) == color                            % found own token -> no valid move
                    break
                end
            else                                                            % out of field boundary -> no valid move
                break
            end
        end
    end
    
    % left
    col = c-1;
    if col > 0 && Grid(r,col) == enemy
        for s = c-2:-1:1                                                    % use loop as colum coordinate, so no check for boundary is necessary
            if Grid(r, s) == 0                                              % valid move
                Moves(r, s, 1) = Moves(r, s, 1) + c-s-1;
                Moves(r, s, 8) = c-s-1;
                break
            elseif Grid(r, s) == color                                      % no valid move
                break
            end
        end
    end
    
    % bottom left
    row = r+1;
    col = c-1;
    if row < 9 && col > 0 && Grid(row,col) == enemy
        for s = 2:7
            tRow = r + s;
            tCol = c - s;
            if tRow < 9 && tCol > 0
                if Grid(tRow, tCol) == 0                                    % valid move
                    Moves(tRow, tCol, 1) = Moves(tRow, tCol, 1) + s-1;
                    Moves(tRow, tCol, 7) = s-1;
                    break
                elseif Grid(tRow, tCol) == color                            % no valid move
                    break
                end
            else                                                            % out of boundary
                break
            end
        end
    end
    
    % top
    row = r-1;
    if row > 0 && Grid(row,c) == enemy
        for s = r-2:-1:1
            if Grid(s, c) == 0                                              % valid move
                Moves(s, c, 1) = Moves(s, c, 1) + r-s-1;
                Moves(s, c, 6) = r-s-1;
                break
            elseif Grid(s, c) == color                                      % no valid move
                break
            end
        end
    end
    
    % bottom
    row = r+1;
    if row < 9 && Grid(row,c) == enemy
        for s = r+2:8
            if Grid(s, c) == 0                                              % valid move
                Moves(s, c, 1) = Moves(s, c, 1) + s-r-1;
                Moves(s, c, 5) = s-r-1;
                break
            elseif Grid(s, c) == color                                      % no valid move
                break
            end
        end
    end
    
    % top right
    row = r-1;
    col = c+1;
    if row > 0 && col < 9 && Grid(row,col) == enemy
        for s = 2:7
            tRow = r - s;
            tCol = c + s;
            if tRow > 0 && tCol < 9
                if Grid(tRow, tCol) == 0                                    % valid move
                    Moves(tRow, tCol, 1) = Moves(tRow, tCol, 1) + s-1;
                    Moves(tRow, tCol, 4) = s-1;
                    break
                elseif Grid(tRow, tCol) == color                            % no valid move
                    break
                end
            else                                                            % out of boundary
                break
            end
        end
    end
    
    % right
    col = c+1;
    if col < 9 && Grid(r,col) == enemy
        for s = c+2:8
            if Grid(r, s) == 0                                              % valid move
                Moves(r, s, 1) = Moves(r, s, 1) + s-c-1;
                Moves(r, s, 3) = s-c-1;
                break
            elseif Grid(r, s) == color                                      % no valid move
                break
            end
        end
    end
    
    % bottom right
    row = r+1;
    col = c+1;
    if row < 9 && col < 9 && Grid(row,col) == enemy
        for s = 2:7
            tRow = r + s;
            tCol = c + s;
            if tRow < 9 && tCol < 9
                if Grid(tRow, tCol) == 0                                    % valid move
                    Moves(tRow, tCol, 1) = Moves(tRow, tCol, 1) + s-1;
                    Moves(tRow, tCol, 2) = s-1;
                    break
                elseif Grid(tRow, tCol) == color                            % no valid move
                    break
                end
            else                                                            % out of boundary
                break
            end
        end
    end
    
end

possMov = find(Moves(:,:,1) > 0);                                           % search for the possible moves contained in the 8x8 matrix "Moves"
numbM =  size(possMov,1);                                                   % get number of possible moves

if step < 2
    
    if numbM < 1                                                            % check if player can do a move
%         profit = mycolor*EvaluateGrid(Grid, mycolor);                                % evaluate the playing field and return the corresponding profit
        profit = EvaluateGrid(Grid, mycolor);                                % evaluate the playing field and return the corresponding profit
        return
    end
    
    for p = 1:numbM
        tempGrid = Grid;                                                    % copy the grid into the temporary grid
        
%%%%    change the temporary grid accordingly to one possible move
        
        x = floor( (possMov(p)-1)/8 +1 );                                                  % determine column of the origin token of the move
        y = mod( (possMov(p)-1), 8 ) + 1;                                                  % determine row of the origin token of the move        
        tempGrid(y,x) = color;                                                          % place origin token of the move
        
        % top left
        for s = 1:Moves(y, x, 2)                                                    % turn x enemy tokens accrodingly to the chosen move
            tempGrid(y-s, x-s) = color;                                                 % turn enemy tokens
        end
        % left
        for s = 1:Moves(y, x, 3)
            tempGrid(y , x-s) = color;
        end
        % bottom left
        for s = 1:Moves(y, x, 4)
            tempGrid(y+s , x-s) = color;
        end
        % top
        for s = 1:Moves(y, x, 5)
            tempGrid(y-s , x) = color;
        end
        % bottom
        for s = 1:Moves(y, x, 6)
            tempGrid(y+s , x) = color;
        end
        % top right
        for s = 1:Moves(y, x, 7)
            tempGrid(y-s , x+s) = color;
        end
        % right
        for s = 1:Moves(y, x, 8)
            tempGrid(y , x+s) = color;
        end
        % bottom right
        for s = 1:Moves(y, x, 9)
            tempGrid(y+s , x+s) = color;
        end

%         temp = mycolor*EvaluateGrid(tempGrid, color);                              % evaluate the temp. grid
        temp = EvaluateGrid(tempGrid, color);                              % evaluate the temp. grid
        if temp <= alpha                                                    % detect a cutoff
            profit = temp;                                                  % assign the profit gained in this part of the search tree
            return                                                          % end the function and search no longer in this part of the search tree
        end
        if temp < beta                                                      % check if the profit of this move is better as the current beta value
            beta = temp;                                                    % update the beta value
        end
    end
    
    profit = beta;                                                          % assign the beta value as profit
    return
end

if numbM < 1                                                                % check if player can do a move
    profit = MaxTokens( Grid, step-1, alpha, beta, ...                      % return the profit without comparing to beta, because the enemy has no choice
        mycolor, timeID, maxTime);
    return
end

for p = 1:numbM                                                             % iterate over every possible move and extend the search tree with this move
    tempGrid = Grid;                                                        % copy the grid into the temporary grid
    
%%%% change the temporary grid accordingly to one possible move
        
    x = floor( (possMov(p)-1)/8 +1 );                                                  % determine column of the origin token of the move
    y = mod( (possMov(p)-1), 8 ) + 1;                                                  % determine row of the origin token of the move    
    tempGrid(y,x) = color;                                                          % place origin token of the move
    
    % top left
    for s = 1:Moves(y, x, 2)                                                    % turn x enemy tokens accrodingly to the chosen move
        tempGrid(y-s, x-s) = color;                                                 % turn enemy tokens
    end
    % left
    for s = 1:Moves(y, x, 3)
        tempGrid(y , x-s) = color;
    end
    % bottom left
    for s = 1:Moves(y, x, 4)
        tempGrid(y+s , x-s) = color;
    end
    % top
    for s = 1:Moves(y, x, 5)
        tempGrid(y-s , x) = color;
    end
    % bottom
    for s = 1:Moves(y, x, 6)
        tempGrid(y+s , x) = color;
    end
    % top right
    for s = 1:Moves(y, x, 7)
        tempGrid(y-s , x+s) = color;
    end
    % right
    for s = 1:Moves(y, x, 8)
        tempGrid(y , x+s) = color;
    end
    % bottom right
    for s = 1:Moves(y, x, 9)
        tempGrid(y+s , x+s) = color;
    end

    temp = MaxTokens( tempGrid, step-1, alpha, beta, ...                    % use the temp. grid to extend the search tree accordingly to the move represented by the temp. grid
        mycolor, timeID, maxTime);
    if temp <= alpha                                                        % detect a cutoff
        profit = temp;                                                      % assign the profit gained in this part of the search tree
        return                                                              % end the function and search no longer in this part of the search tree
    end
    if temp < beta                                                          % check if the profit of this move is better as the current beta value
        beta = temp;                                                        % update the beta value
    end
end

profit = beta;                                                              % assign the beta value as profit
end

function profit = MinZeros(Grid, step, alpha, beta, mycolor, timeID, maxTime)
% This function builds a part of the search tree (one of the enemys turns). To find
% the best move it analyzes the tree by minimizing the outcome for the player.
%
% It returns the exptected profit corresponding to the move which was used
% to call this function (the Grid)
%
% Grid      :=  8x8 matrix representing the playing field
% step      :=  counter tracking the depth of the search tree (0 = leafs)
% alpha     :=  alpha value for the alpha-beta pruning
% beta      :=  beta value for the alpha-beta pruning
% mycolor   :=  color of the player
% timeID    :=  handle of the timer monitoring the program runtime
% maxTime   :=  maximal allowed runtime for the program

if toc(timeID) > maxTime
    profit = Inf;
    return
end

Moves = zeros(25,10);
count = 0;
color = -mycolor;
enemy = -color;
[potR potC] = find(Grid == 0);                                              % search for empty places

for k = 1:size(potR,1)                                                      % iterate over all empty places
    
    r = potR(k);                                                            % row of token
    c = potC(k);                                                            % column of token
    solC = 0;
    
    % top left
    row = r-1;
    col = c-1;
    if row > 0 && col > 0 && Grid(row,col) == enemy                         % search for adjacent enemy token
        for s = 2:7                                                         % search for own token behind enemy tokens
            tRow = r - s;
            tCol = c - s;
            if tRow > 0 && tCol > 0
                if Grid(tRow, tCol) == color                                % found own token -> valid move
                    solC = solC + 1;
                    if solC < 2
                        count = count + 1;
                        Moves(count, 2) = (c-1)*8+r;
                    end
                    Moves(count, 1) = Moves(count, 1) + s-1;                % remember how many tokens can be turned from this position
                    Moves(count, 3) = s-1;                                  % remember how many tokens to turn in this direction
                    break
                elseif Grid(tRow, tCol) == 0                                % found empty place -> no valid move
                    break
                end
            else                                                            % out of field boundary -> no valid move
                break
            end
        end
    end
    
    % left
    col = c-1;
    if col > 0 && Grid(r,col) == enemy
        for s = c-2:-1:1                                                    % use loop as colum coordinate, so no check for boundary is necessary
            if Grid(r, s) == color                                          % valid move
                solC = solC + 1;
                if solC < 2
                    count = count + 1;
                    Moves(count, 2) = (c-1)*8+r;
                end
                Moves(count, 1) = Moves(count, 1) + c-s-1;
                Moves(count, 4) = c-s-1;
                break
            elseif Grid(r, s) == 0                                          % no valid move
                break
            end
        end
    end
    
    % bottom left
    row = r+1;
    col = c-1;
    if row < 9 && col > 0 && Grid(row,col) == enemy
        for s = 2:7
            tRow = r + s;
            tCol = c - s;
            if tRow < 9 && tCol > 0
                if Grid(tRow, tCol) == color                                % valid move
                    solC = solC + 1;
                    if solC < 2
                        count = count + 1;
                        Moves(count, 2) = (c-1)*8+r;
                    end
                    Moves(count, 1) = Moves(count, 1) + s-1;
                    Moves(count, 5) = s-1;
                    break
                elseif Grid(tRow, tCol) == 0                                % no valid move
                    break
                end
            else                                                            % out of boundary
                break
            end
        end
    end
    
    % top
    row = r-1;
    if row > 0 && Grid(row,c) == enemy
        for s = r-2:-1:1
            if Grid(s, c) == color                                          % valid move
                solC = solC + 1;
                if solC < 2
                    count = count + 1;
                    Moves(count, 2) = (c-1)*8+r;
                end
                Moves(count, 1) = Moves(count, 1) + r-s-1;
                Moves(count, 6) = r-s-1;
                break
            elseif Grid(s, c) == 0                                          % no valid move
                break
            end
        end
    end
    
    % bottom
    row = r+1;
    if row < 9 && Grid(row,c) == enemy
        for s = r+2:8
            if Grid(s, c) == color                                          % valid move
                solC = solC + 1;
                if solC < 2
                    count = count + 1;
                    Moves(count, 2) = (c-1)*8+r;
                end
                Moves(count, 1) = Moves(count, 1) + s-r-1;
                Moves(count, 7) = s-r-1;
                break
            elseif Grid(s, c) == 0                                          % no valid move
                break
            end
        end
    end
    
    % top right
    row = r-1;
    col = c+1;
    if row > 0 && col < 9 && Grid(row,col) == enemy
        for s = 2:7
            tRow = r - s;
            tCol = c + s;
            if tRow > 0 && tCol < 9
                if Grid(tRow, tCol) == color                                % valid move
                    solC = solC + 1;
                    if solC < 2
                        count = count + 1;
                        Moves(count, 2) = (c-1)*8+r;
                    end
                    Moves(count, 1) = Moves(count, 1) + s-1;
                    Moves(count, 8) = s-1;
                    break
                elseif Grid(tRow, tCol) == 0                                % no valid move
                    break
                end
            else                                                            % out of boundary
                break
            end
        end
    end
    
    % right
    col = c+1;
    if col < 9 && Grid(r,col) == enemy
        for s = c+2:8
            if Grid(r, s) == color                                          % valid move
                solC = solC + 1;
                if solC < 2
                    count = count + 1;
                    Moves(count, 2) = (c-1)*8+r;
                end
                Moves(count, 1) = Moves(count, 1) + s-c-1;
                Moves(count, 9) = s-c-1;
                break
            elseif Grid(r, s) == 0                                          % no valid move
                break
            end
        end
    end
    
    % bottom right
    row = r+1;
    col = c+1;
    if row < 9 && col < 9 && Grid(row,col) == enemy
        for s = 2:7
            tRow = r + s;
            tCol = c + s;
            if tRow < 9 && tCol < 9
                if Grid(tRow, tCol) == color                                % valid move
                    solC = solC + 1;
                    if solC < 2
                        count = count + 1;
                        Moves(count, 2) = (c-1)*8+r;
                    end
                    Moves(count, 1) = Moves(count, 1) + s-1;
                    Moves(count, 10) = s-1;
                    break
                elseif Grid(tRow, tCol) == 0                                % no valid move
                    break
                end
            else                                                            % out of boundary
                break
            end
        end
    end
    
end

possMov = find(Moves(:,2) > 0);
numbM =  size(possMov,1);

if step < 2
    
    if numbM < 1
%         profit = mycolor*EvaluateGrid(Grid, mycolor);
        profit = EvaluateGrid(Grid, mycolor);
        return
    end
    
    for p = 1:numbM
        tempGrid = Grid;
        
        Ind = possMov(p);
        x = floor( (Moves(Ind,2)-1)/8 +1 );
        y = mod( (Moves(Ind,2)-1), 8 ) + 1;        
        tempGrid(y,x) = color;                                                          % place origin token of the move
        
        % top lef
        for s = 1:Moves(Ind, 3)                                                     % turn enemy tokens accrodingly to the chosen move
            tempGrid(y-s, x-s) = color;
        end
        % left
        for s = 1:Moves(Ind, 4)
            tempGrid(y , x-s) = color;
        end
        % bottom left
        for s = 1:Moves(Ind, 5)
            tempGrid(y+s , x-s) = color;
        end
        % top
        for s = 1:Moves(Ind, 6)
            tempGrid(y-s , x) = color;
        end
        % bottom
        for s = 1:Moves(Ind, 7)
            tempGrid(y+s , x) = color;
        end
        % top right
        for s = 1:Moves(Ind, 8)
            tempGrid(y-s , x+s) = color;
        end
        % right
        for s = 1:Moves(Ind, 9)
            tempGrid(y , x+s) = color;
        end
        % bottom right
        for s = 1:Moves(Ind, 10)
            tempGrid(y+s , x+s) = color;
        end
        
%         temp = mycolor*EvaluateGrid(tempGrid, mycolor);
        temp = EvaluateGrid(tempGrid, mycolor);
        if temp <= alpha                                                    % cutoff
            profit = temp;
            return
        end
        if temp < beta
            beta = temp;
        end
    end
    
    profit = beta;
    return
end

if numbM < 1
    profit = MaxZeros( Grid, step-1, alpha, beta, mycolor, timeID, maxTime);
    return
end

for p = 1:numbM
    tempGrid = Grid;
    
    Ind = possMov(p);
    x = floor( (Moves(Ind,2)-1)/8 +1 );
    y = mod( (Moves(Ind,2)-1), 8 ) + 1;    
    tempGrid(y,x) = color;                                                          % place origin token of the move
    
    % top lef
    for s = 1:Moves(Ind, 3)                                                     % turn enemy tokens accrodingly to the chosen move
        tempGrid(y-s, x-s) = color;
    end
    % left
    for s = 1:Moves(Ind, 4)
        tempGrid(y , x-s) = color;
    end
    % bottom left
    for s = 1:Moves(Ind, 5)
        tempGrid(y+s , x-s) = color;
    end
    % top
    for s = 1:Moves(Ind, 6)
        tempGrid(y-s , x) = color;
    end
    % bottom
    for s = 1:Moves(Ind, 7)
        tempGrid(y+s , x) = color;
    end
    % top right
    for s = 1:Moves(Ind, 8)
        tempGrid(y-s , x+s) = color;
    end
    % right
    for s = 1:Moves(Ind, 9)
        tempGrid(y , x+s) = color;
    end
    % bottom right
    for s = 1:Moves(Ind, 10)
        tempGrid(y+s , x+s) = color;
    end

    temp = MaxZeros( tempGrid, step-1, alpha, beta, mycolor, timeID, maxTime);
    if temp <= alpha                                                        % cutoff
        profit = temp;
        return
    end
    if temp < beta
        beta = temp;
    end
end

profit = beta;
end


% evaluates the playing field with concern of
% - mobility
% - stone difference
% - x-squares
% - game over case
% - corners
function score = EvaluateGrid( Grid, color )

gameState = sum(sum(Grid == 0));                                            % count zeros to determine progress of game

% weights for: stone difference (until endgame always zero), corner,
% x-squares and game over
diff = 0;
% wx = -16*color;
wd = color;
wc = 50*color;
wwo = -10000;

% count possible moves for player and enemy
if gameState < 36

    % use zeros to search for possible moves
    [potR potC] = find(Grid == 0);                                              % search for empty places
    NumbMovesOwn = 0;
    tempColor = color;
    enemy = -tempColor;
    
    for k = 1:size(potR,1)                                                      % iterate over all empty places
        
        r = potR(k);                                                            % row of token
        c = potC(k);                                                            % column of token
        
        % top left
        row = r-1;
        col = c-1;
        if row > 0 && col > 0 && Grid(row,col) == enemy                         % search for adjacent enemy token
            for s = 2:7                                                         % search for own token behind enemy tokens
                tRow = r - s;
                tCol = c - s;
                if tRow > 0 && tCol > 0
                    if Grid(tRow, tCol) == color                                % found own token -> valid move
                        NumbMovesOwn = NumbMovesOwn + 1;
                        break
                    elseif Grid(tRow, tCol) == 0                                % found empty place -> no valid move
                        break
                    end
                else                                                            % out of field boundary -> no valid move
                    break
                end
            end
        end
        
        % left
        col = c-1;
        if col > 0 && Grid(r,col) == enemy
            for s = c-2:-1:1                                                    % use loop as colum coordinate, so no check for boundary is necessary
                if Grid(r, s) == color                                          % valid move
                    NumbMovesOwn = NumbMovesOwn + 1;
                    break
                elseif Grid(r, s) == 0                                          % no valid move
                    break
                end
            end
        end
        
        % bottom left
        row = r+1;
        col = c-1;
        if row < 9 && col > 0 && Grid(row,col) == enemy
            for s = 2:7
                tRow = r + s;
                tCol = c - s;
                if tRow < 9 && tCol > 0
                    if Grid(tRow, tCol) == color                                % valid move
                        NumbMovesOwn = NumbMovesOwn + 1;
                        break
                    elseif Grid(tRow, tCol) == 0                                % no valid move
                        break
                    end
                else                                                            % out of boundary
                    break
                end
            end
        end
        
        % top
        row = r-1;
        if row > 0 && Grid(row,c) == enemy
            for s = r-2:-1:1
                if Grid(s, c) == color                                          % valid move
                    NumbMovesOwn = NumbMovesOwn + 1;
                    break
                elseif Grid(s, c) == 0                                          % no valid move
                    break
                end
            end
        end
        
        % bottom
        row = r+1;
        if row < 9 && Grid(row,c) == enemy
            for s = r+2:8
                if Grid(s, c) == color                                          % valid move
                    NumbMovesOwn = NumbMovesOwn + 1;
                    break
                elseif Grid(s, c) == 0                                          % no valid move
                    break
                end
            end
        end
        
        % top right
        row = r-1;
        col = c+1;
        if row > 0 && col < 9 && Grid(row,col) == enemy
            for s = 2:7
                tRow = r - s;
                tCol = c + s;
                if tRow > 0 && tCol < 9
                    if Grid(tRow, tCol) == color                                % valid move
                        NumbMovesOwn = NumbMovesOwn + 1;
                        break
                    elseif Grid(tRow, tCol) == 0                                % no valid move
                        break
                    end
                else                                                            % out of boundary
                    break
                end
            end
        end
        
        % right
        col = c+1;
        if col < 9 && Grid(r,col) == enemy
            for s = c+2:8
                if Grid(r, s) == color                                          % valid move
                    NumbMovesOwn = NumbMovesOwn + 1;
                    break
                elseif Grid(r, s) == 0                                          % no valid move
                    break
                end
            end
        end
        
        % bottom right
        row = r+1;
        col = c+1;
        if row < 9 && col < 9 && Grid(row,col) == enemy
            for s = 2:7
                tRow = r + s;
                tCol = c + s;
                if tRow < 9 && tCol < 9
                    if Grid(tRow, tCol) == color                                % valid move
                        NumbMovesOwn = NumbMovesOwn + 1;
                        break
                    elseif Grid(tRow, tCol) == 0                                % no valid move
                        break
                    end
                else                                                            % out of boundary
                    break
                end
            end
        end
        
    end
    
    NumbMovesEnemy = 0;
    tempColor = -color;
    enemy = -tempColor;
    
    for k = 1:size(potR,1)                                                      % iterate over all empty places
        
        r = potR(k);                                                            % row of token
        c = potC(k);                                                            % column of token
        
        % top left
        row = r-1;
        col = c-1;
        if row > 0 && col > 0 && Grid(row,col) == enemy                         % search for adjacent enemy token
            for s = 2:7                                                         % search for own token behind enemy tokens
                tRow = r - s;
                tCol = c - s;
                if tRow > 0 && tCol > 0
                    if Grid(tRow, tCol) == color                                % found own token -> valid move
                        NumbMovesEnemy = NumbMovesEnemy + 1;
                        break
                    elseif Grid(tRow, tCol) == 0                                % found empty place -> no valid move
                        break
                    end
                else                                                            % out of field boundary -> no valid move
                    break
                end
            end
        end
        
        % left
        col = c-1;
        if col > 0 && Grid(r,col) == enemy
            for s = c-2:-1:1                                                    % use loop as colum coordinate, so no check for boundary is necessary
                if Grid(r, s) == color                                          % valid move
                    NumbMovesEnemy = NumbMovesEnemy + 1;
                    break
                elseif Grid(r, s) == 0                                          % no valid move
                    break
                end
            end
        end
        
        % bottom left
        row = r+1;
        col = c-1;
        if row < 9 && col > 0 && Grid(row,col) == enemy
            for s = 2:7
                tRow = r + s;
                tCol = c - s;
                if tRow < 9 && tCol > 0
                    if Grid(tRow, tCol) == color                                % valid move
                        NumbMovesEnemy = NumbMovesEnemy + 1;
                        break
                    elseif Grid(tRow, tCol) == 0                                % no valid move
                        break
                    end
                else                                                            % out of boundary
                    break
                end
            end
        end
        
        % top
        row = r-1;
        if row > 0 && Grid(row,c) == enemy
            for s = r-2:-1:1
                if Grid(s, c) == color                                          % valid move
                    NumbMovesEnemy = NumbMovesEnemy + 1;
                    break
                elseif Grid(s, c) == 0                                          % no valid move
                    break
                end
            end
        end
        
        % bottom
        row = r+1;
        if row < 9 && Grid(row,c) == enemy
            for s = r+2:8
                if Grid(s, c) == color                                          % valid move
                    NumbMovesEnemy = NumbMovesEnemy + 1;
                    break
                elseif Grid(s, c) == 0                                          % no valid move
                    break
                end
            end
        end
        
        % top right
        row = r-1;
        col = c+1;
        if row > 0 && col < 9 && Grid(row,col) == enemy
            for s = 2:7
                tRow = r - s;
                tCol = c + s;
                if tRow > 0 && tCol < 9
                    if Grid(tRow, tCol) == color                                % valid move
                        NumbMovesEnemy = NumbMovesEnemy + 1;
                        break
                    elseif Grid(tRow, tCol) == 0                                % no valid move
                        break
                    end
                else                                                            % out of boundary
                    break
                end
            end
        end
        
        % right
        col = c+1;
        if col < 9 && Grid(r,col) == enemy
            for s = c+2:8
                if Grid(r, s) == color                                          % valid move
                    NumbMovesEnemy = NumbMovesEnemy + 1;
                    break
                elseif Grid(r, s) == 0                                          % no valid move
                    break
                end
            end
        end
        
        % bottom right
        row = r+1;
        col = c+1;
        if row < 9 && col < 9 && Grid(row,col) == enemy
            for s = 2:7
                tRow = r + s;
                tCol = c + s;
                if tRow < 9 && tCol < 9
                    if Grid(tRow, tCol) == color                                % valid move
                        NumbMovesEnemy = NumbMovesEnemy + 1;
                        break
                    elseif Grid(tRow, tCol) == 0                                % no valid move
                        break
                    end
                else                                                            % out of boundary
                    break
                end
            end
        end
        
    end
    
    mob = NumbMovesOwn - NumbMovesEnemy;                                        % get difference of possible moves    
  
else

    % use tokens to search for possible moves
    Moves = zeros(8,8);                                                       % allocate "Moves" matrix
    tempColor = color;
    enemy = -tempColor;                                                             % define enemy color
    [potR potC] = find(Grid == tempColor);                                          % search for own tokens
    
    for k = 1:size(potR,1)                                                      % iterate over all own tokens
        
        r = potR(k);                                                            % row of token
        c = potC(k);                                                            % column of token
        
        % top left
        row = r-1;                                                              % adjust row accordingly to the direction
        col = c-1;                                                              % adjust column accordingly to the direction
        if row > 0 && col > 0 && Grid(row,col) == enemy                         % search for adjacent enemy token and check if values are within the playing field boundaries
            for s = 2:7                                                         % search for emtpy field behind enemy tokens
                tRow = r - s;                                                   % adjust row accordingly to the direction
                tCol = c - s;                                                   % adjust column accordingly to the direction
                if tRow > 0 && tCol > 0                                         % check if values are within the playing field boundaries
                    if Grid(tRow, tCol) == 0                                    % found empty field -> valid move
                        Moves(tRow, tCol) = 1;                                  % remember how many tokens can be turned in total from this position
                        break
                    elseif Grid(tRow, tCol) == tempColor                            % found own token -> no valid move
                        break
                    end
                else                                                            % out of field boundary -> no valid move
                    break
                end
            end
        end
        
        % left
        col = c-1;
        if col > 0 && Grid(r,col) == enemy
            for s = c-2:-1:1                                                    % use loop as colum coordinate, so no check for boundary is necessary
                if Grid(r, s) == 0                                              % valid move
                    Moves(r, s) = 1;
                    break
                elseif Grid(r, s) == tempColor                                      % no valid move
                    break
                end
            end
        end
        
        % bottom left
        row = r+1;
        col = c-1;
        if row < 9 && col > 0 && Grid(row,col) == enemy
            for s = 2:7
                tRow = r + s;
                tCol = c - s;
                if tRow < 9 && tCol > 0
                    if Grid(tRow, tCol) == 0                                    % valid move
                        Moves(tRow, tCol) = 1;
                        break
                    elseif Grid(tRow, tCol) == tempColor                            % no valid move
                        break
                    end
                else                                                            % out of boundary
                    break
                end
            end
        end
        
        % top
        row = r-1;
        if row > 0 && Grid(row,c) == enemy
            for s = r-2:-1:1
                if Grid(s, c) == 0                                              % valid move
                    Moves(s, c) = 1;
                    break
                elseif Grid(s, c) == tempColor                                      % no valid move
                    break
                end
            end
        end
        
        % bottom
        row = r+1;
        if row < 9 && Grid(row,c) == enemy
            for s = r+2:8
                if Grid(s, c) == 0                                              % valid move
                    Moves(s, c) = 1;
                    break
                elseif Grid(s, c) == tempColor                                      % no valid move
                    break
                end
            end
        end
        
        % top right
        row = r-1;
        col = c+1;
        if row > 0 && col < 9 && Grid(row,col) == enemy
            for s = 2:7
                tRow = r - s;
                tCol = c + s;
                if tRow > 0 && tCol < 9
                    if Grid(tRow, tCol) == 0                                    % valid move
                        Moves(tRow, tCol) = 1;
                        break
                    elseif Grid(tRow, tCol) == tempColor                            % no valid move
                        break
                    end
                else                                                            % out of boundary
                    break
                end
            end
        end
        
        % right
        col = c+1;
        if col < 9 && Grid(r,col) == enemy
            for s = c+2:8
                if Grid(r, s) == 0                                              % valid move
                    Moves(r, s) = 1;
                    break
                elseif Grid(r, s) == tempColor                                      % no valid move
                    break
                end
            end
        end
        
        % bottom right
        row = r+1;
        col = c+1;
        if row < 9 && col < 9 && Grid(row,col) == enemy
            for s = 2:7
                tRow = r + s;
                tCol = c + s;
                if tRow < 9 && tCol < 9
                    if Grid(tRow, tCol) == 0                                    % valid move
                        Moves(tRow, tCol) = 1;
                        break
                    elseif Grid(tRow, tCol) == tempColor                            % no valid move
                        break
                    end
                else                                                            % out of boundary
                    break
                end
            end
        end
        
    end
    
    NumbMovesOwn = sum(sum(Moves));
    
    Moves = Moves*0;
    tempColor = -color;
    enemy = -tempColor;                                                             % define enemy color
    [potR potC] = find(Grid == tempColor);                                          % search for own tokens
    
    for k = 1:size(potR,1)                                                      % iterate over all own tokens
        
        r = potR(k);                                                            % row of token
        c = potC(k);                                                            % column of token
        
        % top left
        row = r-1;                                                              % adjust row accordingly to the direction
        col = c-1;                                                              % adjust column accordingly to the direction
        if row > 0 && col > 0 && Grid(row,col) == enemy                         % search for adjacent enemy token and check if values are within the playing field boundaries
            for s = 2:7                                                         % search for emtpy field behind enemy tokens
                tRow = r - s;                                                   % adjust row accordingly to the direction
                tCol = c - s;                                                   % adjust column accordingly to the direction
                if tRow > 0 && tCol > 0                                         % check if values are within the playing field boundaries
                    if Grid(tRow, tCol) == 0                                    % found empty field -> valid move
                        Moves(tRow, tCol) = 1;                                  % remember how many tokens can be turned in total from this position
                        break
                    elseif Grid(tRow, tCol) == tempColor                            % found own token -> no valid move
                        break
                    end
                else                                                            % out of field boundary -> no valid move
                    break
                end
            end
        end
        
        % left
        col = c-1;
        if col > 0 && Grid(r,col) == enemy
            for s = c-2:-1:1                                                    % use loop as colum coordinate, so no check for boundary is necessary
                if Grid(r, s) == 0                                              % valid move
                    Moves(r, s) = 1;
                    break
                elseif Grid(r, s) == tempColor                                      % no valid move
                    break
                end
            end
        end
        
        % bottom left
        row = r+1;
        col = c-1;
        if row < 9 && col > 0 && Grid(row,col) == enemy
            for s = 2:7
                tRow = r + s;
                tCol = c - s;
                if tRow < 9 && tCol > 0
                    if Grid(tRow, tCol) == 0                                    % valid move
                        Moves(tRow, tCol) = 1;
                        break
                    elseif Grid(tRow, tCol) == tempColor                            % no valid move
                        break
                    end
                else                                                            % out of boundary
                    break
                end
            end
        end
        
        % top
        row = r-1;
        if row > 0 && Grid(row,c) == enemy
            for s = r-2:-1:1
                if Grid(s, c) == 0                                              % valid move
                    Moves(s, c) = 1;
                    break
                elseif Grid(s, c) == tempColor                                      % no valid move
                    break
                end
            end
        end
        
        % bottom
        row = r+1;
        if row < 9 && Grid(row,c) == enemy
            for s = r+2:8
                if Grid(s, c) == 0                                              % valid move
                    Moves(s, c) = 1;
                    break
                elseif Grid(s, c) == tempColor                                      % no valid move
                    break
                end
            end
        end
        
        % top right
        row = r-1;
        col = c+1;
        if row > 0 && col < 9 && Grid(row,col) == enemy
            for s = 2:7
                tRow = r - s;
                tCol = c + s;
                if tRow > 0 && tCol < 9
                    if Grid(tRow, tCol) == 0                                    % valid move
                        Moves(tRow, tCol) = 1;
                        break
                    elseif Grid(tRow, tCol) == tempColor                            % no valid move
                        break
                    end
                else                                                            % out of boundary
                    break
                end
            end
        end
        
        % right
        col = c+1;
        if col < 9 && Grid(r,col) == enemy
            for s = c+2:8
                if Grid(r, s) == 0                                              % valid move
                    Moves(r, s) = 1;
                    break
                elseif Grid(r, s) == tempColor                                      % no valid move
                    break
                end
            end
        end
        
        % bottom right
        row = r+1;
        col = c+1;
        if row < 9 && col < 9 && Grid(row,col) == enemy
            for s = 2:7
                tRow = r + s;
                tCol = c + s;
                if tRow < 9 && tCol < 9
                    if Grid(tRow, tCol) == 0                                    % valid move
                        Moves(tRow, tCol) = 1;
                        break
                    elseif Grid(tRow, tCol) == tempColor                            % no valid move
                        break
                    end
                else                                                            % out of boundary
                    break
                end
            end
        end
        
    end
    
    NumbMovesEnemy = sum(sum(Moves));
    mob = NumbMovesOwn - NumbMovesEnemy;                                 % get difference of possible moves    

end

% check gamestate and calculate values for each case
if (gameState < 16)
    wx = -16*color;
    diff = 4*sum(sum(Grid));                                                % calculate sum of all stone son playing field
    wm = 4;
    we = 5*color;
 elseif (gameState < 32)
    wx = -16*color;
    wm = 5;
    we = 4*color;
elseif (gameState < 48)
    wx = -32*color;
    wm = 6;
    we = 3*color;
elseif (gameState < 64)
    wx = -50*color;
    wm = 7;
    we = 0;
end

edges = (sum(Grid(1,3:6)) + sum(Grid(3:6,1)) + sum(Grid(8,3:6)) ...         % count tokens at the edges
    + sum(Grid(3:6,8)));

corner = Grid(1,1) + Grid(8,1) + Grid(1,8)+ Grid(8,8);                      % count tokens in the corners

xsquare = 0;
if Grid(1) == 0
    xsquare = xsquare + sum(Grid([2,9,10]));
end
if Grid (8) == 0
    xsquare = xsquare + sum(Grid([7,15,16]));
end
if Grid (57) == 0
    xsquare = xsquare + sum(Grid([49,50,58]));
end
if Grid (64) == 0
    xsquare = xsquare + sum(Grid([55,56,63]));
end

% check if game is lost, if not calculate score
if (sum(sum(Grid == color)) == 0 )
    score = wwo;
else
    score = wd*diff + wm*mob + we*edges + wc*corner + wx*xsquare;                 % score = sum of criterias multiplied with their weights
end

end
