function [depth, weights] = DGT_searchDepth(time, numOfTurns)
% Determine the search depth of the negamax algorithm and the weights for
% the heuristic.
% weights: CoinParity, Mobility, CornersCaptured, Stability/Heatmap

nStart = 15;
nMid = 45;
nKiller = 54;
% Early 
if numOfTurns <= nStart
    depth = 5;
    weights = [5 20 10 10];
% Mid
elseif numOfTurns <= nMid
    depth = 6;
    weights = [5 10 10 20];
% Late
elseif numOfTurns < nKiller
    depth = 8;
    weights = [5 0 5 10];
% Killer Move
else
    depth = 60-numOfTurns;
    weights = [10 0 0 0];
end
% Normalisieren
weights = weights/sum(weights(:));

%% Adapt depth if time is critical
if time < 3
    depth = 1;
elseif time < 5
    depth = 2;
elseif time < 10
    depth = 4;
elseif time < 20
    depth = 5;
end
    

end