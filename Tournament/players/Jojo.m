function b = Jojo(b,color,t)
    % Weights for Heueristics:
    % 1) Coint Parity 2) Mobility 3) Corner Possesion 4) Stability
    addpath(['players' filesep 'Jojo']);
    
    nTurn = getTurn(b);
    
    
    [depth, w] = getParams(nTurn, t);
    move = JalphaBeta( b, color, depth, w );
    
    if ~isempty(move)
        b = simulateMove(b,color,move); 
    end 
end


