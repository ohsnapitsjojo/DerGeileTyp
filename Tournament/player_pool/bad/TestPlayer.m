function b = TestPlayer(b,color,t)
    addpath(['players' filesep 'TestPlayer']);
    
    possible_moves = free2set(b, color);
    
    if sum(possible_moves(:)) == 0
        b = b;
    else
        [c,d] = MiniMax(b, color, 3);
        b = put_stone(b, d, color);
    end
    
end