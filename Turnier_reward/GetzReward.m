function b = GetzReward(b,player,t,weights)

    % füge Unterordner hinzu, damit Funktionen gefunden werden
    currentFullFilename = which('GetzReward.m');
    [pathStr,~,~] = fileparts(currentFullFilename);
    addpath([pathStr filesep 'GetzReward']);
    
    % number of past turns
    numOfTurns = sum(sum(b ~= 0))-4;
    % search depth and weights
    [depth, ~] = DGRT_searchDepth(t, numOfTurns);
   depth=5;
    [~,b_best] = DGRT_negamax(b, player, -inf, inf, depth, weights);
    
    if ~isempty(b_best)
        b = b_best; 
    end 
end

