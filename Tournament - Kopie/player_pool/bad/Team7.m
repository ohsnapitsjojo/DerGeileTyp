function [move t] = Team7Main(field, colour, t)

persistent stoneCounter;

    if t>179.9
        stoneCounter=0;
    end
        
    stoneCounter=stoneCounter+1
    depth =6;
    
    
    if stoneCounter == 23
        depth = 9;
    end
    if stoneCounter == 24
        depth = 8;
    end 
    if stoneCounter == 25
        depth = 7;
    end
    if stoneCounter == 26
        depth = 6;
    end
    endGame = 0;
    move = [];
    depth
    
    % variable depth according to remaining time
%     if t > 176 
%         depth = 3;
%     elseif t < 176 && t > 20
%         depth = 8;
%end
    if t <= 20
        depth = 1;
        endGame = 1; 
    end  
    
    % init of points
    decisionValue = -Inf;
    alpha = -Inf;
    beta = Inf;
    
    % create all possible field matrices out of current gaming situation,
    % it means all possible moves [8 x 8 x possibleMoves]
    nextMoves = nextMovesFunction(field, colour);
    if isempty(nextMoves)
       move=field;
       return
    end
    % extract amount of children nodes ( = possibleMoves ) from nextMoves
    possibleMoves = numel(nextMoves) / 64;
    

    % iterate through all children nodes ...
    for index = 1:possibleMoves
        % until we reach the lowest layer (=leaves)
        if depth == 0 
            % and get the evaluated gaming value
            costValue = evaluate(nextMoves(:,:,index), colour, endGame, stoneCounter);
        else
            % else apply alpha - beta algorithm on all children (depth - 1)
            costValue = minValue_AlphaBeta(nextMoves(:,:,index), colour*(-1), depth - 1, alpha, beta, endGame,stoneCounter);
        end

        % if return value (evaluated point) is greater than the evaluated
        % value before, set it as new maximum. do this for each iteration
        % cycle, until maximum value was found
        if costValue >= decisionValue
            decisionValue = costValue;
            % according to current iteration index, set the next gaming
            % situation (= our next move) to the currently indexed
            % nextMoves Matrix -> equally to choosing a path in the tree
            % that we want to go in the next step
            move = nextMoves(:,:,index);          
        end

    end 
  
     % finally return this field ( = move ) to the othello server 
     
end 
















function [ nextMoves ] = nextMovesFunction( field, color )



% valid index precalculation
    persistent ownColorComparePatternMatrix;
    persistent enemyColorComparePatternMatrix;
    persistent rawDepthSearchMatrix;
    persistent depthSearchIndexer;
    persistent weightMatrix;
        
    % only compute once! persistent variables will survive the return
    % statement and be available for next next_moves request
    if isempty(depthSearchIndexer)
        
        maximalStones = 64;

        
        % preorder allows sorting for alpha - beta algorithm
        % the depth search will return all indices for valid stones to 
        % be set, and then preorder will be mapped to these indices 
%         weightMatrix = zeros(10,10,'double');
%         weightMatrix(2:9,2:9) = double([120  10    30 25 25 30  10   120 ;
%                                     10  -100   30 20 20 30 -100  10  ;
%                                     30   30    15 10 10 15  30   30  ;
%                                     25   20    10 10 10 10  20   25  ;
%                                     25   20    10 10 10 10  20   25  ;
%                                     30   30    15 10 10 15  30   30  ;
%                                     10  -100   30 20 20 30 -100  10  ;
%                                     120  10    30 25 25 30  10   120]);
% 
%         weightMatrix = weightMatrix * (-1);
        
        
        
        a = 20;
        b = 30; 
        c = 60;
              
        d = 220;
        e = 220;
        f = 220;
        g = 220;
        
        h = -120;
        i = -115;
        j = -110;
        k = -100;
        

        % costs lookup table
        weightMatrix = zeros(10,10,'double');
        weightMatrix(2:9,2:9) = [        d  h  c  b  b  c  i  e ;
                                         h  h  h  h  h  h  i  i ;
                                         c  k  a  a  a  a  i  c ;
                                         b  k  b  a  a  a  i  b ;
                                         b  k  b  a  a  a  i  b ;
                                         c  k  a  a  a  a  i  c ;
                                         k  k  j  j  j  j  j  j ;
                                         g  k  c  b  b  c  j  f];
                            
        weightMatrix = weightMatrix * (-1);
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        % primary structure of depth field matrix
        % e.g. 1 2 3 means there are 3 stones in a row
        % -1000 is an arbitrairy value for delimiting
                       
        offsetStructure = [  1 2 -120 -120 -120 -120 -120; ...
                             1 2 3     -120 -120 -120 -120; ...
                             1 2 3     4     -120 -120 -120; ...
                             1 2 3     4     5     -120 -120; ...
                             1 2 3     4     5     6     -120; ...
                             1 2 3     4     5     6     7];        
        
        
                         
                         
                         
        ownColorComparePatternMatrix = [1 -1  0  0  0  0  0; ...
                                       1  1 -1  0  0  0  0; ...
                                       1  1  1 -1  0  0  0; ...
                                       1  1  1  1 -1  0  0; ...
                                       1  1  1  1  1 -1  0; ...
                                       1  1  1  1  1  1 -1];
       
                     
        % create eye matrix [6 x 512]            
                     
        eye_6 = zeros(6, maximalStones * 7 * 8);
        eye_6(1:7:(maximalStones * 6 * 7 * 8)) = 1;
        eye_6(:,7:7:(maximalStones * 7 * 8)) = [];  
 
        % repeat ownColorValueMatrix 512 times: (in order to get 3072 rows)
%      1    -1     0     0     0     0     0
%      1     1    -1     0     0     0     0
%      1     1     1    -1     0     0     0
%      1     1     1     1    -1     0     0
%      1     1     1     1     1    -1     0
%      1     1     1     1     1     1    -1
%      1    -1     0     0     0     0     0
%      1     1    -1     0     0     0     0
%      1     1     1    -1     0     0     0
%      1     1     1     1    -1     0     0
%      1     1     1     1     1    -1     0
%      1     1     1     1     1     1    -1
%                     ...
%                     ...
%                     ...
        ownColorComparePatternMatrix = double(eye_6' * ownColorComparePatternMatrix);
        enemyColorComparePatternMatrix = double(ownColorComparePatternMatrix * (-1));        
        
        
        
        
        
        
%          the indices around a stone in a 10x10 matrix:
%         
%         -11  -1   9
%         -10   X  10
%         - 9   1  11
        
        neighborMatrix = [  eye(6);...
                        (-1)*eye(6);...
                        (-9)*eye(6);...
                        (-10)*eye(6); ...
                        (-11)*eye(6);...
                        9*eye(6);...
                        10*eye(6);...
                        11*eye(6)];

        
        % dimension: [48 x 7]
        % if one stone is set, there are maximal 48 possibilities for other
        % stones
        indexBlock = neighborMatrix * offsetStructure;
        

        
        % create raw depth search lookup table 
        rawDepthSearchMatrix = [];
        % counter is a scalar between 0 and 64
        currentStoneNumber = 0;
        % scalar index goes from 12 to 19 and then from 22 to 29 and so on
        for index = [12:19 22:29 32:39 42:49 52:59 62:69 72:79 82:89]
            currentStoneNumber = currentStoneNumber + 1;
            
            % there are 64 possibilities to set a stone
            % for each stone there are 48 possible neighbor paths/hoods
            rawDepthSearchMatrix(((currentStoneNumber - 1) * 48 + 1) : currentStoneNumber * 48 ,1:7) = indexBlock + index;
            
            % rows: multiple of 48 ( times counter ), column = 8  -> set
            % possible stone position index (12, 13 ... 89 ) 
            rawDepthSearchMatrix(((currentStoneNumber - 1) * 48 + 1) : currentStoneNumber * 48 ,8) = index;
        end
        % limit value range(=index) between 1 and 100
        rawDepthSearchMatrix((rawDepthSearchMatrix < 1) | (rawDepthSearchMatrix > 100)) = 1;
        
        % dimensions: [3072 x 8]
        rawDepthSearchMatrix = double(rawDepthSearchMatrix);
        
        
        % not each row in rawDepthSearchMatrix determines a valid
        % index path, so we need a special indexer
        depthSearchIndexer = 1:100;
        % determines the row number of each block (48 x 12, 48 x 13 and so
        % on) 
        depthSearchIndexer([12:19 22:29 32:39 42:49 52:59 62:69 72:79 82:89]) = (1:64) * 48;
        for i = 1:48
            % create matrix out of vector with all possible entries of the
            % rawDepthSearch matrix
            depthSearchIndexer(i,:) = depthSearchIndexer(1,:) + (i-1);
        end
        depthSearchIndexer = double(depthSearchIndexer - 47);
        
    end
    
 % valid index precalculation finished
 
 
 
    
    
    % create [10x10] matrix with current field content end extended edge    
    extendedField = zeros(10,10,'double');
    extendedField(2:9,2:9) = double(field);

    % find all enemyStones and store them
    enemyStones = find(extendedField == (color*(-1)));

    % find all stones and store them
    allCurrentlySetStones = double(extendedField ~= 0);
    
    % neighborPosition calculates all possible positions, on that we could
    % place a new stone, it takes the enemyStones index variable and simply
    % set its neighbors in the matrix to 1
    neighborPosition = zeros(10,10,'double');   
    neighborPosition([  enemyStones-1; ...
                        enemyStones+1; ...
                        enemyStones-9; ...
                        enemyStones-10; ...
                        enemyStones-11; ...
                        enemyStones+9; ...
                        enemyStones+10; ...
                        enemyStones+11]) = 1;
    
    % allowedFields contains all possible positions to set a stone minus
    % the positions, on that a stone is already set
    allowedFields = neighborPosition - double(neighborPosition & allCurrentlySetStones);
    % in case something goes beyond the edge, set it to 0
    allowedFields([1:10 11:10:81 91:100 20:10:90]) = 0;
    % store all allowedField indices in a vector
    allCurrentlySetStones = double(find(allowedFields == 1));
    

    % in case there is no possibility for current player to set a new stone
    if isempty(allCurrentlySetStones)
        nextMoves = [];
        % no new move possible
        return;
    end

    % select all columns from depthSearchIndexer with all currently
    % possible moves(allstones)
    temp = depthSearchIndexer(:, allCurrentlySetStones);
    % select rows from rawDepthSearchMatrix, that are indexed by temp
    allValidDepthSearchIndices = rawDepthSearchMatrix(temp(:), :);    
    

     % erase all rows out of depth search matrix, which indices do not
    % represent a valid path for current gaming situation (example below)
    if color == 1
        % dim(temp1) = dim(temp2) = [length(allStones)*48 x 7]
        tmp1 = enemyColorComparePatternMatrix(1:size(allCurrentlySetStones,1)*48,:);
        tmp2 = extendedField(allValidDepthSearchIndices(:, 1:7));
       allValidDepthSearchIndices(  any( ~(tmp1 == tmp2) , 2 )  , : )  = [];
    else
        tmp1 = ownColorComparePatternMatrix(1:size(allCurrentlySetStones,1)*48,:);
        tmp2 = extendedField(allValidDepthSearchIndices(:, 1:7));
       allValidDepthSearchIndices(any( ~(tmp1 == tmp2),2),:)  = [];
    end   
    
    
    % example:
    % player color = 1
    % received field from othello server:
    
%      0     0     0     0     0     0     0     0
%      0     0     0     0     0     0     0     0
%      0     0     0     0     0     0     0     0
%      0     0     0     1    -1     0     0     0
%      0    -1    -1    -1     1     0     0     0
%      0     0     0     0     0     0     0     0
%      0     0     0     0     0     0     0     0
%      0     0     0     0     0     0     0     0

% --> extended [10x10] field with 0-edges
%      0     0     0     0     0     0     0     0     0     0
%      0     0     0     0     0     0     0     0     0     0
%      0     0     0     0     0     0     0     0     0     0
%      0     0     0     0     0     0     0     0     0     0
%      0     0     0     0     1    -1     0     0     0     0
%      0     0    -1    -1    -1     1     0     0     0     0
%      0     0     0     0     0     0     0     0     0     0
%      0     0     0     0     0     0     0     0     0     0
%      0     0     0     0     0     0     0     0     0     0
%      0     0     0     0     0     0     0     0     0     0    
% index matrix [10x10] with extended edge     
%      1    11    21    31    41    51    61    71    81    91
%      2    12    22    32    42    52    62    72    82    92
%      3    13    23    33    43    53    63    73    83    93
%      4    14    24    34    44    54    64    74    84    94
%      5    15    25    35    45    55    65    75    85    95
%      6    16    26    36    46    56    66    76    86    96
%      7    17    27    37    47    57    67    77    87    97
%      8    18    28    38    48    58    68    78    88    98
%      9    19    29    39    49    59    69    79    89    99
%     10    20    30    40    50    60    70    80    90   100
    
% --> depth search matrix after cutting away not needed rows:
%     26    36    46    56     1     1     1    16
%     36    45     1     1     1     1     1    27
%     46    45     1     1     1     1     1    47
%     55    56     1     1     1     1     1    54
%     55    45     1     1     1     1     1    65

% the 8. column denotes the new set stone index(e.g. in first row = 16) and
% all values between this value 16 and 56 mark a valid path(here:
% horizontal path)
% later than, this path will be used to set our own color(overwrite old
% field values) => = flip stones!

    % end of example

    

    
    % weighting for alpha beta algorithm:
    
    % create [100 x 3] matrix: [ (1:100)' , 100 times 0, all preorder values linearized ]
    sortedValidDepthSearchIndices = double([(1:100)' zeros(100,1) weightMatrix(:)]);
    % set 1 in second column indexed by all positions returned by the depth search
    % allDepthSearchIndices(:,8) contains the desired indices for valid moves! 
    sortedValidDepthSearchIndices(allValidDepthSearchIndices(:,8),2) = 1;
    % erase all the other rows, where is no 1 in second column
    sortedValidDepthSearchIndices(any(~sortedValidDepthSearchIndices(:,2),2),:) = [];
    % according to preorder matrix, each position on the field can be
    % classified as better or worse for alpha-beta-algorithm -> therefore
    % sort the result of the depth search in this way, that the first 
    % child node(which will be iterated by alpha-beta), is optimal for this
    % algorithm and so it is able to skip all the other children paths ->
    % = runtime optimization
    sortedValidDepthSearchIndices = sortrows(sortedValidDepthSearchIndices, 3);
    
    
    % finally create 3 dimensional ([8 x 8 x amount of children nodes])
    % next move matrix
    nextMoves = zeros(8,8,size(sortedValidDepthSearchIndices,1),'double');
    % for each child do...
    for i = 1:size(sortedValidDepthSearchIndices,1)
           % get all indices from the sorted depth search between old stone
           % and new set stone
           % take 8th column of allDepthSearchIndices(new set stone pos),
           % take i-th entry of first column(indices) of sortedDepthSearchIndices
           % compare them -> temp(i=1)=  row of alldepthSearchIndices with highest priority  
           extractedPath = allValidDepthSearchIndices( allValidDepthSearchIndices(:,8) == sortedValidDepthSearchIndices(i,1), : );
           f = extendedField;
           % now flip stones: set own color on all these indexed positions
           % (simply overwrite the old values)
           f(extractedPath(:)) = color;
           % extract [8 x 8, i] field layer out of [10 x 10 x i] field
           % layer
           nextMoves(1:8,1:8, i) = f(2:9,2:9);
    end  
end

















% alpha = best value for player A so far
% beta  = best value for player B so far
% -> alpha and beta determine a search window

% alpha beta break condition:  global beta < global alpha  



%                     |A|                       max layer
%                     
%      |B|            |C|            |D|        min layer
%             
%  |E| |F| |G|    |H| |I| |J|    |K| |L| |M|
%  |3| |9| |8|    |2| |4| |6|    |9| |5| |2|

% -->

%                     |A| alpha = 3             max layer
%                     
%      |B| beta=3     |C|            |D|        min layer
%             
%  |E| |F| |G|    |H| |I| |J|    |K| |L| |M|
%  |3| |9| |8|    |2| |4| |6|    |9| |5| |2|

% -->

%                     |A| alpha = 3             max layer
%                     
%      |B|            |C| beta=2     |D|        min layer
%             
%  |E| |F| |G|    |H| |I| |J|    |K| |L| |M|
%  |3| |9| |8|    |2| |4| |6|    |9| |5| |2|

% --> beta < alpha --> I and J will be skipped, because we (maximiser)
% would never choose path C, because path B has greater beta(3) than 
% path C (beta = 2)
% it is the same in path D, however due to the not sorted 
% children nodes(9,5,2) all subpaths are iterated and finally we also
% see, that beta is 2 and therefore smaller than 3 -> we would also not
% choose path D, because path B has greater value

% during first call, alpha is set to -inf and beta to +inf
function [decisionValue, alpha, beta] = minValue_AlphaBeta(field, colour, depth, alpha, beta, endGame,stoneCounter)


    % if we reach the lowest layer ( leaves ) than break alpha - beta
    % algorithm recursion in order to evaluate(return decision value)
    if depth == 0 
        decisionValue = evaluate(field, colour, endGame,stoneCounter);
        % break statement
        return
    end

    % else: at the first place, get all possible next gaming situation, it
    % means all possible next moves field matrices [8x8xpossibleMoves],
    %  where possibleMoves is the amount of children in the
    % lower layer (depth-1) of the gaming tree
    nextMoves = nextMovesFunction(field, colour);
    % extract possibleMoves = amount of children
    possibleMoves = numel(nextMoves) / 64;

    % set local beta to highest possible value -> player B wants to
    % minimize, so therefore localBeta is only updated, when a smaller
    % value is found in the first child node. Then it continues to compare
    % with the second, third etc. child node and only if there are smaller
    % points in those nodes, the just set localBeta will be updated. If
    % there is no smaller value than localBeta in the next node, this node
    % will be skipped
    localBeta = inf;
    
    % iterate through all children nodes...
    for index = 1:possibleMoves
        % and call opposite alpha - beta min/max function (recursion)
        [costValue alpha beta] = maxValue_AlphaBeta(nextMoves(:,:,index), colour*(-1), depth-1, alpha, beta, endGame,stoneCounter);

        % first condition: found cost value in child node has to be smaller 
        % than the temporary beta in the current minimization layer
        if costValue < localBeta
           % and if child node value is also smaller than global alpha...
           if costValue < alpha
               % alpha beta condition is fulfilled, thus set return value
               % to costValue and do a return out of this recursion layer
               decisionValue = costValue;
               return
           end
           % if alpha beta condition not yet fulfilled, than update
           % localBeta value with costValue
           localBeta = costValue;
           % if costValue smaller ( = better ) than global beta...
           if costValue < beta
               % set beta with this better value ( minimization! )
               beta = costValue;
           end
        end
    end 
    % all paths iterated, no alpha beta optimization was possible...
    % simply return localBeta
    decisionValue = localBeta;
end 


function [decisionValue, alpha, beta] = maxValue_AlphaBeta(field, colour, depth, alpha, beta, endGame,stoneCounter)

    % if we reached the lowest layer ( leaves ) than break alpha - beta algorithm in order to evaluate 
    if depth == 0 
        decisionValue = evaluate(field, colour, endGame,stoneCounter);
        % break statement
        return
    end

    % else: at the first place, get all possible next gaming situation, it
    % means all possible next moves field matrices [8x8xpossibleMoves],
    %  where possibleMoves is the amount of children in the
    % lower layer (depth-1) of the gaming tree
    nextMoves = nextMovesFunction(field, colour);
    % extract possibleMoves = amount of children
    possibleMoves = numel(nextMoves) / 64;

    % set localAlpha to lowest possible value -> player A wants to
    % maximize, so therefore localAlpha is only updated, when a greater
    % value is found in the first child node. Then it continues to compare
    % with the second, third etc. child node and only if there are greater
    % points in those nodes, localAlpha will be updated. If
    % there is no greater value than localAlpha in the next child node, 
    % than this will be skipped
    localAlpha = -inf;

    % iterate through all children...
    for index = 1:possibleMoves
        % and call opposite alpha - beta min/max function (recursion)
        [costValue alpha beta] = minValue_AlphaBeta(nextMoves(:,:,index), colour*(-1), depth-1, alpha, beta, endGame,stoneCounter);

        % first condition: found cost value in child node has to be bigger 
        % than the temporary alpha in the current maximization layer
        if costValue > localAlpha
            % and if value from child node is bigger than global beta... 
            if costValue > beta
                % ... set decisionValue (result) and skip all other paths,
                % because alpha beta condition is fulfilled
                decisionValue = costValue;
                return
            end
            % else: if costValue not bigger than beta...
            % overwrite localAlpha with costValue
            localAlpha = costValue;
            % however, if costValue bigger ( = better ) than global alpha
            if costValue > alpha
                % update globalAlpha with this value(maximisation!)
                alpha = costValue;
            end
        end
        % ...and continue searching, until found a costValue that is bigger than
        % global beta !
    end
    
    % all paths have been walked through without alpha beta optimization...
    % set decisionValue to localAlpha
    decisionValue = localAlpha; 

end










function [costValue] = evaluationFunction(field, endGame,stoneCounter)

    % if we only have about 20 seconds left to play, we change the
    % evaluation matrix in this way, that each stone has the same
    % worthiness, since it is necessary in the end game to collect most of
    % the stones
    if endGame == 1             
        temp = double(field);
        temp = temp.*[ 1    1   1   1   1   1   1   1;...
                       1    1   1   1   1   1   1   1;...
                       1    1   1   1   1   1   1   1;...
                       1    1   1   1   1   1   1   1;...
                       1    1   1   1   1   1   1   1;...
                       1    1   1   1   1   1   1   1;...
                       1    1   1   1   1   1   1   1;...
                       1    1   1   1   1   1   1   1]; 
        % and sum up all points in order to get a costValue
        costValue = sum(temp(:));
        return; 
    end 

    % now multiply elementwise evaluation matrix
    a=1;
    b=2;
    c=-4;
    d=-3;
    e=-4;
    f=200;
    g=-5;
    h= 10;
    k=8;
    
    
   % if stoneCounter <23
        temp = double(field);
        temp = temp.*[   f    g      h      k      k      h     g    f  ; ...
                         g    c      d      e      e      d     c    g   ; ... 
                         h    d      b      a      a      b     d    h  ; ... 
                         k    e      a      a      a      a     e    k  ; ...
                         k    e      a      a      a      a     e    k  ; ... 
                         h    d      b      a      a      b     d    h  ; ...
                         g    c      d      e      e      d     c    g   ; ...
                         f    g      h      k      k      h     g    f ];           
    %end
    
%     if stoneCounter>15
%         temp = double(field);
%         temp = temp.*[   5000    -1000       300      200      200      300    -1000    5000  ; ...
%                      -1000     1000      -1       -1       -1       -1      1000    -1000   ; ... 
%                      300    -1      5      5      5      5     -1    300  ; ... 
%                      200    -1      5      5      5      5     -1    200  ; ...
%                      200    -1      5      5      5      5     -1    200  ; ... 
%                      300    -1      5      5      5      5     -1    300  ; ...
%                      -1000   1000      -1       -1       -1       -1      1000    -1000   ; ...
%                      5000    -1000      300      200      200      300     -1000    5000 ];    
%     end
%                  
%     if stoneCounter>=23
%         temp = double(field);
%         temp = temp.*[ 50    1   1   1   1   1   1   50;...
%                        1    40   1   1   1   1   40   1;...
%                        1    1   30   1   1   30   1   1;...
%                        1    1   1   2   2   1   1   1;...
%                        1    1   1   2   2   1   1   1;...
%                        1    1   30   1   1   30   1   1;...
%                        1    40   1   1   1   1   40   1;...
%                        50    1   1   1   1   1   1   50];        
%     end
                 
    % sum up all elements in temporary matrix in order to get a scalar costValue, that 
    % describes the evaluation of that current gaming situation
    costValue = sum(temp(:));
end




function [costValue] = evaluate(field, color, endGame,stoneCounter)
    % depending on current color, apply positive or negative sign on
    % evaluation matrix
    if color == -1
        field = field .* (-1);
    end
    costValue = evaluationFunction(field, endGame,stoneCounter);
end

