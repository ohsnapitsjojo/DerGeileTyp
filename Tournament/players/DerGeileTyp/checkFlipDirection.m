function [flag] = checkFlipDirection(b,color,move,direction)
% Gibt zur�ck ob sich nach dem Setzten eines Streines an position move
% mindestens ein gegnerischer Strein Flipt beim verfolgen der Richtung
% direction
    flag = false;
    opponentFound = false;  % Bezeichnet das finden eines Gegnerischen steines in der untersuchten linie
    opponent = -1*color;
    
    x = ceil(move/8);
    y = mod(move,8);  
    if(y==0)
        y = 8;  % Gesamte Rechnung is ohne idx2xy Funktionsaufruf ca 1/3 schneller
    end
    
    while 0<x && x<9 && 0<y && y<9 
        x = x + direction(1);
        y = y + direction(2);
        
        if x<1 || y<1 || 8<x || 8<y         % Failsafe f�r Indexfehler
            break;
        end
        
        if b(y,x) == 0                      % Es gibt keine druchgehende Verbindung von Streinen
            flag = false;
            break;
        end

        if b(y,x) == opponent && ~opponentFound     % Finde gegnerischen Stein im Pfad
            opponentFound = true;
        end
        if b(y,x) == color && ~opponentFound        % Es gibt keinen g�ltigen pfad und es werden keine Steine geflippt 
            flag = false;
            break;
        end
        if b(y,x) == color && opponentFound         % Finde eigenen Stein nach einem gegnerischen im Pfad
            flag = true;
            break;    
        end
    end 
end


