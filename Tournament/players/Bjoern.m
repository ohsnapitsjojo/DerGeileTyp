function b = Bjoern(b,color,t)
addpath(['players' filesep 'Bjoern']);
    % Weights for Heueristics:
    % 1) Coint Parity 2) Mobility 3) Corner Possesion 4) Stability
   w= [0.403817063326295 0.259237888641430 0.328798866297672 0.00814618173460235];
   %w=[0.607726966322105 0.948002359333351 0.0596416235853658 0.268712345242794];
   %w=[0.965257748969727 0.628267352552455 0.132031170054907 0.618301778328654];
   Turn=getTurn(b);
   if Turn>50
       depth=6;
       w=[0.3 0.1 0.3 0.3];
   else
       depth=6;
   end
    move = alphaBeta( b, color,depth, w );
    
    if ~isempty(move)
        b = simulateMove(b,color,move); 
    end 
end

