function [ depth, w ] = getParams( t, time )

 % Weights for Heueristics:
 % 1) Coint Parity 2) Mobility 3) Corner Possesion 4) Stability
    nMid = 15;
    nLate = 30;
    nLate2 = 50;
    
    if t < nMid
        depth = 4;
        %w = [0 1 0 1];
        w = [0 1 0 1];
    elseif t < nLate
        depth = 4;
        %w = [0 1 2 1];
        w = [0 2 5 1];
    elseif t < nLate2 
        depth = 4;
        %w = [0 1 10 5];
        w = [0 1 10 5];
    else
        depth = 61-t;
        %w = [1 0 0 0];
        w = [5 0 5 0];
    end
    
    

    w = w/sum(w);
    
end

