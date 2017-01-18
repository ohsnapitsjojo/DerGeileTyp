function b_best = DerGeileGetz(b,player,timeLeft)
% Othello player 

    % start clock for this turn
    tStart = tic;
    
    % add subfolder to find functions
    currentFullFilename = which('DerGeileGetz.m');
    [pathStr,~,~] = fileparts(currentFullFilename);
    addpath([pathStr filesep 'DerGeileGetz']);
    
    % number of past turns
    numOfTurns = sum(sum(b ~= 0))-4;
    % weights for heuristics
    weights = [0, ...                           % Coin Parity
               2*(312 + 6.24*numOfTurns), ...   % Stability
               36, ...                          % Heatmap + Corners
               (75 + numOfTurns), ...           % Current Mobility
               99];                             % Potential Mobility    
    if numOfTurns <= 25
        weights(4) = 50 + 2*numOfTurns;
    end   
    
    % calculate possible moves (random move as backup)
    [b_tmp, moves] = DGG_legalMoves(b, player); 
    
    % calculate max time for choosing a move
    movesLeft = 30-floor(numOfTurns/2);
    maxTime = timeLeft / movesLeft;
    
    
    try
        for depth = 1:movesLeft
            
            % start clock for dearch iteration
            tIteration = tic;
            
            % check if remaining game can be evaluated completely
            if depth >= movesLeft
                weights = [1 0 0 0 0];
            end
            
            % negamax search
            [~,b_best,numNodes] = DGG_negamax(b, player, -inf, inf, depth, weights, moves, maxTime, tStart);
            
            % always iterate at least two times
            if depth < 3
                continue;
            end
            
            % check if enough time for search with greater depth
            timeIteration = toc(tIteration);   
            timeEstimate = nthroot(numNodes,depth)^(depth+1) * timeIteration/numNodes;
            timeSpend = toc(tStart);
            if timeSpend+timeEstimate > maxTime
                break;
            end
            
        end
    catch
        
        % backup: choose random move
        idx = randi(numel(moves));
        b_best = b_tmp(:,:,idx);

    end
    
    % backup: choose random move
    if isempty(b_best)
        idx = randi(numel(moves));
        b_best = b_tmp(:,:,idx);
    end

end

