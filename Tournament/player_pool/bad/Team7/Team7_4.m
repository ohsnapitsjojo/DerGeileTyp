%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% input: current playground, current stone color, remaining time
%
%
%
% following function descriptions needed: 
%   fieldDeallocation()
%   flipStones
% what does tmpGameMatrix do?
%
%
%
% output: new playground, remaining time - deltaT(gameMoveTeam7)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [newPlayground t] = Team7_4(playground,color,t)

    addpath('players/Team7_4');
    
    global finalMove;
    global currentMove;
    currentMove = [];

    % internal convertion of color
    if color == -1
        tempcolor = 1;
    elseif color == 1
        tempcolor = 2;
    end


    tempPlayground = zeros(8,8);

    % internal convertion of playground vals
    % -1  ->  1
    % 1   ->  2
    for i = 1:8
        for j = 1:8
            if playground(i,j) == -1
                tempPlayground(i,j) = 1;
            elseif playground(i,j) == 1
                tempPlayground(i,j) = 2;
            elseif playground(i,j) == 0
                tempPlayground(i,j) = 0;
            end
        end
    end


    
    % this function will have following tasks:
    %   find all indices of our own stones and store them temporarily
    %   find all indices of enemy stones and the indices of its
    %   adjecent(neighbor) empty fields
    %   if there is no move possible, return empty matrix
    tmpGameMatrix = fieldDeallocation(tempPlayground,tempcolor);

    % check, if a legal move was possible, else: skip round without doing anything 
    if ~isempty(tmpGameMatrix)
        % check if there is still gaming time left
        if t > 20
            % apply minmax / alpha beta algorithm in order to find the best new stone position
            % needs:
            %   cost function
            %   tree operations
            stone = minmax(tempPlayground,tempcolor);
        else
            disp('Not enough time...')
            for k = 1: size(tmpGameMatrix,1)
                moveValue(tempPlayground,tmpGameMatrix(k,:),tempcolor);
            end
            % if there is no time left, apply emergency emergencyStrategy
            stone = emergencyStrategy();
        end
        
        
        % finally set own color value on calculated index in
        % playgroundmatrix and ...
        tempPlayground(tmpGameMatrix(stone,1),tmpGameMatrix(stone,2)) = tempcolor;
        finalMove = [tmpGameMatrix(stone,1) tmpGameMatrix(stone,2)];
        % ... store this move as a 2dim final move ( like move:3,5 )
        
        % flipStones:
        %   must be able to detect, how many stones are between
        %   old set stones and the new one set in this cycle and
        %   finally turn them(simply swap the value, e.g. -1 -> 1)
        tempPlayground = flipStones(tempPlayground, finalMove, tempcolor);
    end
    %main action ended!
    
    
    
    % reverse convertion of playground vals -> for return values
    for i = 1:8
        for j = 1:8
            if tempPlayground(i,j) == 1
                playground(i,j) = -1;
            end
            if tempPlayground(i,j) == 2
                playground(i,j) = 1;
            end
            if tempPlayground(i,j) == 0
                playground(i,j) = 0;
            end
        end
    end

    newPlayground = playground;

end


function setStone = minmax(playground,color)

    gameTree = createTree(playground,color);

    lastLayer = gameTree{size(gameTree,2)};

    for i = 1:size(lastLayer,2)
           currentLastLayer = lastLayer{i};
           weightedLastLayer{i} = costsVecFunction(currentLastLayer,color);      
    end

           weightedTree{size(gameTree,2)} = weightedLastLayer;

    for k = size(gameTree,2):-1:2

        currentLayer = weightedTree{k};

        if mod(k,2) == 0
            for l = 1: size(currentLayer,2)
            weightedVec(l) = min(currentLayer{l});    
            end
        else
            for l = 1: size(currentLayer,2)
            weightedVec(l) = max(currentLayer{l});    
            end
        end

        currentLayerGameTree = gameTree{k-1};

        for o = 1: size(currentLayerGameTree,2)

            z = 1;

            for s = 1:size(currentLayerGameTree{o},3) 

                weightedTree{k-1}{o}(s) = weightedVec(z);
                z = z+1;

            end

        end

    end

    [finalWeight index] = max(weightedTree{1}{1});


    setStone = index;

end


% 
% function tempKo = stoneCoordinates(playground, moveField, color)
% 
%     global turnVec;
% 
% 
%     x = moveField(1,2);
%     y = moveField(1,1);
%     searchingPos = zeros(1,2);
%     tmpTurnVec = zeros(1,2);
% 
%     for i = -1:1:1
%         for k = -1:1:1
%             if ((y+k) < 9) && ((y+k) > 0) && ((x+i) < 9) && ((x+i) > 0)
%                 if((playground(y+k,x+i) ~= 0) && (playground(y+k,x+i) ~= color))
%                     searchingPos(1) = y+k;
%                     searchingPos(2) = x+i;
%                     continueSearching(playground, moveField, searchingPos, color, tmpTurnVec);
%                 end
%             end
%         end
%     end
% 
% 
%     tempKo = [moveField; turnVec];
% 
%     turnVec = [];
% end


function index = emergencyStrategy()
    global currentMove;
    maximum = max(currentMove(:,1));

    for i = 1 : size(currentMove,1)
        if currentMove(i,1) == maximum
            index = i;
            break;
        end
    end

    return

end

