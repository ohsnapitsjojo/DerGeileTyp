function b = Pwndthello(b,color,t)
    addpath(['players' filesep 'Pwndthello']);
%     M = findAllowedPositions(b, color);
    M = findAllowedPositions(b, color);
    r = rand()*length(M);
    m = M(ceil(r), 1)
    n = M(ceil(r), 2)
    [b, changed] = makeMove(b, color, m, n);    
end