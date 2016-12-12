function b = DerGeileTyp(b,color,t)
    % Weights for Heueristics:
    % 1) Coint Parity 2) Mobility 3) Corner Possesion 4) Stability
    w = [1 10 100 1];
   
    
    move = greedyAgent(b,color,w,'h');
    
    if ~isempty(move)
        b = simulateMove(b,color,move); 
    end 
end

