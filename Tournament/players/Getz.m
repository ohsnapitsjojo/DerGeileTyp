function b = Getz(b,player,t)

    % füge Unterordner hinzu, damit Funktionen gefunden werden
    currentFullFilename = which('Getz.m');
    [pathStr,~,~] = fileparts(currentFullFilename);
    addpath([pathStr filesep 'Getz']);
    
    % number of past turns
    numOfTurns = sum(sum(b ~= 0))-4;
    % search depth and weights
    [depth, weights] = DGT_searchDepth(t, numOfTurns);
   
    [~,b_best] = DGT_negamax(b, player, -inf, inf, depth, weights);
    
    if ~isempty(b_best)
        b = b_best; 
    end 
end

