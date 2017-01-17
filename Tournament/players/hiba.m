function b = hiba(b, color, t)

addpath(['players' filesep 'Hiba']);
w= [0.403817063326295 0.259237888641430 0.328798866297672 0.00814618173460235];



%% 
depth = gdepth(b, t);

    move = alphaBeta( b, color, depth, w );
    
    if ~isempty(move)
        b = simulateMove(b,color,move); 
end 



end

