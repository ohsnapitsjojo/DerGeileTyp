function v = DGG_getLeafValue(b, player, weights, moves)
% Calculate heuristics to evaluate board

    opponent = -player;

%% Coin Parity   
    ratio = sum(b(:));
    ratio = ratio*player;
    b_square = b.^2;
    sumOfAllStones = sum(b_square(:));

    h_coinParity = 1000*(ratio/sumOfAllStones);

%% Mobility
    % current mobility
    [~, movesPlayer] = DGG_legalMoves(b, player);
    movesOpponent = moves;
    
    moveMapPlayer = zeros(1,64);
    moveMapPlayer(movesPlayer) = 1;
    moveMapOpponent = zeros(1,64);
    moveMapOpponent(movesOpponent) = 1;
    
    numMovesBoth = sum(moveMapPlayer & moveMapOpponent) ;
    numMovesPlayer = 2*(numel(movesPlayer)-numMovesBoth) + numMovesBoth;
    numMovesOpponent = 2*(numel(movesOpponent)-numMovesBoth) + numMovesBoth;   
  
    h_currMobility = 1000*(numMovesPlayer-numMovesOpponent)/(numMovesPlayer+numMovesOpponent+2);
    
    % potential mobility
    numFrontierDiscsOpponent = sum(sum((conv2(double(b==0), ones(3), 'same')) & (b==opponent)));
    numEmptyPosOpponent = sum(sum((conv2(double(b==opponent), ones(3), 'same')~= 0) & (b==0)));
    numEmptyPosOpponentWeighted = sum(sum((conv2(double(b==opponent), ones(3), 'same')) .* (b==0)));
    
    numFrontierDiscsPlayer = sum(sum((conv2(double(b==0), ones(3), 'same')) & (b==player)));
    numEmptyPosPlayer = sum(sum((conv2(double(b==player), ones(3), 'same')~= 0) & (b==0)));
    numEmptyPosPlayerWeighted = sum(sum((conv2(double(b==player), ones(3), 'same')) .* (b==0)));
    
    h_frontierDiscs = 1000*(numFrontierDiscsPlayer-numFrontierDiscsOpponent)/(numFrontierDiscsPlayer+numFrontierDiscsOpponent+2);
    h_emptyPos = 1000*(numEmptyPosPlayer-numEmptyPosOpponent)/(numEmptyPosPlayer+numEmptyPosOpponent+2);
    h_emptyPosWeighted = 1000*(numEmptyPosPlayerWeighted-numEmptyPosOpponentWeighted)/(numEmptyPosPlayerWeighted+numEmptyPosOpponentWeighted+2);
    
    if numFrontierDiscsPlayer == 0 || numFrontierDiscsOpponent == 0
        h_potentialMobility = 0;
    else
        h_potentialMobility = h_frontierDiscs + h_emptyPos + h_emptyPosWeighted;
    end


%% Corners Captured
    corners = [b(1,1) b(1,8) b(8,1) b(8,8)];
    numCornersPlayer = sum(corners==player);
    numCornersOpponent = sum(corners==opponent);

    h_cornersCaptured = 1000*(numCornersPlayer-numCornersOpponent)/(numCornersPlayer+numCornersOpponent+2);
 
 
    
%% Heatmap


    heatMap =[1000 -300 100  80  80 100 -300 1000;
              -300 -500 -45 -50 -50 -45 -500 -300;
               100  -45   3   1   1   3  -45  100;
                80  -50   1   5   5   1  -50   80;
                80  -50   1   5   5   1  -50   80;
               100  -45   3   1   1   3  -45  100;
              -300 -500 -45 -50 -50 -45 -500 -300;
              1000 -300 100  80  80 100 -300 1000];

    
    heatPlayer = sum(heatMap(b==player));
    heatOpponent = sum(heatMap(b==opponent));
    totalHeat = abs(abs(heatPlayer) + abs(heatOpponent) + 2);
    
    if totalHeat ~= 0
        h_heatmap = 1000 * (heatPlayer - heatOpponent)/totalHeat;
    else
        h_heatmap = 0;
    end
    
%% Stability
   
    numStablePlayer = DGG_getNumOfStable(b,player);
    numStableOpponent = DGG_getNumOfStable(b,opponent); 
      
    h_stability = 1000*(numStablePlayer-numStableOpponent)/(numStablePlayer+numStableOpponent+2);
    


    
    
%% Final Value

v = weights(1) * h_coinParity + ...
    weights(2) * h_stability + ...
    weights(3) * (h_cornersCaptured + h_heatmap) + ...
    weights(4) * h_currMobility + ...
    weights(5) * -h_potentialMobility;



end



function [ numStable ] = DGG_getNumOfStable( b,player )
% Gibt die Anzahl der stabilen Steine der Farbe player zurück
    stabilityBoard = zeros(8,8);
    
    %Corner 1
    if b(1,1) == player
        % maximale stabile spalte basierend auf stabilen steinen in der reihe
        maxScol = 7;        
        for row = 1:7
            for col = 1:maxScol
                if b(row,col) == player
                    % Steine die an stabile Steine angrenzen sind auch hier
                    % stabil
                    stabilityBoard(row,col) = 1;
                else
                    % Spalte muss nicht weiter untersuchter werden weil kein
                    % stabiler Stein gefunden wurde
                    maxScol = col -1;
                    break;
                end
            end
        end
        maxSrow = 7;
        for col = 1:7
            for row = 1:maxSrow
                if b(row,col) == player
                    stabilityBoard(row,col) = 1;
                else
                    maxSrow = row-1;
                    break;
                end
            end
        end
    end
    %Corner 2
    if b(8,1) == player
        maxScol = 7;           
        for row = 8:-1:2
            for col = 1:maxScol
                if b(row,col) == player
                    stabilityBoard(row,col) = 1;                
                else
                    maxScol = col-1;
                    break;
                end
            end
        end
        maxSrow = 2;           
        for col = 1:7
            for row = 8:-1:maxSrow
                if b(row,col) == player
                    stabilityBoard(row,col) = 1;                
                else
                    maxSrow = row+1;
                    break;
                end
            end
        end
    end 
    %Corner 3
    if b(1,8) == player
        maxScol = 2;           
        for row = 1:7
            for col = 8:-1:maxScol
                if b(row,col) == player
                    stabilityBoard(row,col) = 1;                
                else
                    maxScol = col+1;
                    break;
                end
            end
        end
        maxSrow = 7;           
        for col = 8:-1:2
            for row = 1:maxSrow
                if b(row,col) == player
                    stabilityBoard(row,col) = 1;                
                else
                    maxSrow = row-1;
                    break;
                end
            end
        end
    end 
    %Corner 4
    if b(8,8) == player
        maxScol = 2;           
        for row = 8:-1:2
            for col = 8:-1:maxScol
                if b(row,col) == player
                    stabilityBoard(row,col) = 1;                
                else
                    maxScol = col+1;
                    break;
                end
            end
        end
        maxSrow = 2;           
        for col = 8:-1:2
            for row = 8:-1:maxSrow
                if b(row,col) == player
                    stabilityBoard(row,col) = 1;                
                else
                    maxSrow = row+1;
                    break;
                end
            end
        end
    end
    % Anzahl Stabiler Steine
    numStable = sum(stabilityBoard(:));
end
