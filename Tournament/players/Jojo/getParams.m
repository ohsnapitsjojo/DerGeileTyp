function [ depth, w ] = getParams( t, time )

 % Weights for Heueristics:
 % 1) Coint Parity 2) Mobility 3) Corner Possesion 4) Stability
    nMid = 20;
    nLate = 45;
    %nLate = 60;
    
    if t < nMid
        depth = 3;
        w = [0 1 1 1];
    elseif t < nLate
        depth = 5;
        w = [0 1 3 3];
    else 
        depth = 61-t;
        w = [3 0 1 3];
    end
    
    

    w = w/sum(w);
    
end

