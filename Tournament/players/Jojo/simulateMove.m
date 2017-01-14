function b  = simulateMove( b, color, move )
% Simuliert das Ergebniss eines Zuges move
    if isempty(move)
        return 
    end
    directions = {[0,-1] [1,1] [0,1] [1,-1] [-1,0] [-1,-1] [1, 0] [-1,1]};
    
    [x, y] = Jidx2xy(move);
    
    b(y,x) = color;                                 % Setzt deinen Stein
    
    for idx = 1:length(directions)
        
        direction = directions{idx};
        [x, y] = Jidx2xy(move);

        if checkFlipDirection(b,color,move,direction) 
             while 0<x && x<9 && 0<y && y<9 
                x = x + direction(1);
                y = y + direction(2);
                
                if x<1 || y<1 || 8<x || 8<y         % Failsafe für Indexfehler
                    break;
                end	
                if b(y,x) == color                  % Pfad der steine die geflippt werden endet
                    break;
                else                                % Gegnerischer Stein wird geflippt 
                    b(y,x) = color;
                end
             end 
        end   
    end
end

