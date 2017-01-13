function b = MiniMaxPlayer(b,color,t)
    addpath(['players' filesep 'MiniMaxPlayer']);
    [val, b] = negamax(b, 4, color);
end