function v = DGT_getBoardValue(b, player, w)
% Calculate heuristics to evaluate board

opponent = -player;

%% Coin Parity
ratio = sum(b(:));
ratio = ratio*player;
b_square = b.^2;
sumOfAllStones = sum(b_square(:));

h_coinParity = 100*(ratio/sumOfAllStones);

%% Mobility
[~, movesPlayer] = DGT_legalMoves(b, player);
[~, movesOpponent] = DGT_legalMoves(b, opponent);
numMovesPlayer = numel(movesPlayer);
numMovesOpponent = numel(movesOpponent);   

if (numMovesPlayer + numMovesOpponent) ~= 0
    h_mobility = 100*(numMovesPlayer-numMovesOpponent)/(numMovesPlayer+numMovesOpponent);
else
    h_mobility = 0;
end

if numMovesPlayer==0 %end of game
    v = h_coinParity;
    return;
end

%% Corners Captured
corners=[b(1,1) b(1,8) b(8,1) b(8,8)];
numCornersPlayer = sum(corners==player);
numCornersOpponent = sum(corners==opponent);

if numCornersPlayer+numCornersOpponent ~= 0
    h_cornersCaptured=100*(numCornersPlayer-numCornersOpponent)/(numCornersPlayer+numCornersOpponent);
else
    
    h_cornersCaptured = 0;
end
%% Stability


heatMap =[1000 -300 100  80  80 100 -300 1000;
       -300 -500 -45 -50 -50 -45 -500 -300;
        100  -45   3   1   1   3  -45  100;
         80  -50   1   5   5   1  -50   80;
         80  -50   1   5   5   1  -50   80;
        100  -45   3   1   1   3  -45  100;
       -300 -500 -45 -50 -50 -45 -500 -300;
       1000 -300 100  80  80 100 -300 1000];

    
    stabilityPlayer = sum(heatMap(b==player));
    stabilityOpponent = sum(heatMap(b==opponent));
    totalStability = abs(stabilityPlayer + stabilityOpponent);
    
    if totalStability ~= 0
        h_stability = 100 * (stabilityPlayer - stabilityOpponent)/totalStability;
    else
        h_stability = 0;
    end
    
%% Final Value
v = w(1) * h_coinParity + ...
    w(2) * h_mobility + ...
    w(3) * h_cornersCaptured + ...
    w(4) * h_stability;
    

end