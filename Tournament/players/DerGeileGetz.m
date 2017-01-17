function b = DerGeileGetz(b,player,t)

    % füge Unterordner hinzu, damit Funktionen gefunden werden
    currentFullFilename = which('DerGeileGetz.m');
    [pathStr,~,~] = fileparts(currentFullFilename);
    addpath([pathStr filesep 'DerGeileGetz']);
    
    % number of past turns
    numOfTurns = sum(sum(b ~= 0))-4;
    % search depth and weights
    [depth, weights] = DGG_searchDepth(t, numOfTurns);
   
    [~,b_best] = DGG_negamax(b, player, -inf, inf, depth, weights);
    
    if ~isempty(b_best)
        b = b_best; 
    end 
end

