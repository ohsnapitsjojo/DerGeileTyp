function [ depth, w ] = getParams( t, time )

 % Weights for Heueristics:
 % 1) Coint Parity 2) Mobility 3) Corner Possesion 4) Stability
    nMid = 15;
    nLate = 40;
    nLate2 = 50;
    
    if t < nMid
        depth = 3;
        w = [0 1 1 1];
    elseif t < nLate
        depth = 3;
        w = [0 2 5 1];
    elseif t < nLate2 
        depth = 6;
        w = [0 1 5 3];
    else
        depth = 61-t;
        w = [1 0 0 0];
    end
    
    

    w = w/sum(w);
    
end

