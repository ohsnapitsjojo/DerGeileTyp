function b = Jojo(b,color,t)
    % Weights for Heueristics:
    % 1) Coint Parity 2) Mobility 3) Corner Possesion 4) Stability
    w = [1 10 100 1];
    nTurn = getTurn(b);
    
    %move = greedyAgent(b,color,w,'h');
    
    [depth, w] = getParams(nTurn, t);
    move = alphaBeta( b, color, depth, w );
    
    if ~isempty(move)
        b = simulateMove(b,color,move); 
    end 
end

