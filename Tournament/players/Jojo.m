<<<<<<< HEAD
function b = Jojo(b,color,t)
    % Weights for Heueristics:
    % 1) Coint Parity 2) Mobility 3) Corner Possesion 4) Stability
    addpath(['players' filesep 'Jojo']);
    
    nTurn = getTurn(b);
    
    %move = greedyAgent(b,color,w,'h');
    
    [depth, w] = getParams(nTurn, t);
    move = JalphaBeta( b, color, depth, w );
    
    if ~isempty(move)
        b = simulateMove(b,color,move); 
    end 
end

=======
function b = E(b,color,t)
    % Weights for Heueristics:
    % 1) Coint Parity 2) Mobility 3) Corner Possesion 4) Stability

    nTurn = getTurn(b);
    
    %move = greedyAgent(b,color,w,'h');
    
    [depth, w] = getParams(nTurn, t);
    move = JalphaBeta( b, color, depth, w );
    
    if ~isempty(move)
        b = simulateMove(b,color,move); 
    end 
end

>>>>>>> 2d02e9d9e7bdcc96ec1b19bcdda39ef0f28ddf7a
