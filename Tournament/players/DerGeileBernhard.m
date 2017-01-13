function [ b] = DerGeileBernhard( b,color,t )
    % Weights for Heueristics:
    % 1) Coint Parity 2) Mobility 3) Corner Possesion 4) Stability
    % Veränderliche Parameter: depth,w
    n = getnRounds(b);
    if color == -1 
        if n < 40
            depth = 4;
            w = [1 10 100 1];
        elseif n >= 40
            depth = 4;
            w = [1 1 10 10];
        elseif n >= 55
            depth = 7;
            w = [100 1 1 1];
        end
    else
        if n < 40
            w = [1 100 100 1];
            depth = 3;
        elseif n >= 40
            depth = 7;
            w = [100 1 100 1];
        end
    end

    move = alphaBeta( b, color, depth , w );
    
    if ~isempty(move)
        b = simulateMove(b,color,move); 
    end 
end

