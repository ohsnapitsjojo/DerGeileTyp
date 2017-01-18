function [flag] = G4_checkFlipDirection(b,color,move,direction)
% Gibt zurück ob sich nach dem Setzten eines Streines an position move
% mindestens ein gegnerischer Strein Flipt beim verfolgen der Richtung
% direction
    flag = false;
    opponentFound = false;  % Bezeichnet das finden eines Gegnerischen steines in der untersuchten linie
    opponent = -1*color;
    %% Berechnung ohne Funktionaufruf über idx2xy ca 33% schneller
    x = ceil(move/8);
    y = mod(move-1,8)+1;

    %%
    while 0<x && x<9 && 0<y && y<9 
        x = x + direction(1);
        y = y + direction(2);
        
        if x<1 || y<1 || 8<x || 8<y         % Failsafe für Indexfehler
            break;
        end
        
        if b(y,x) == 0                      % Es gibt keine druchgehende Verbindung von Streinen
            flag = false;
            break;
        end

        if b(y,x) == opponent && ~opponentFound     % Finde gegnerischen Stein im Pfad
            opponentFound = true;
        end
        if b(y,x) == color && ~opponentFound        % Es gibt keinen gültigen pfad und es werden keine Steine geflippt 
            flag = false;
            break;
        end
        if b(y,x) == color && opponentFound         % Finde eigenen Stein nach einem gegnerischen im Pfad
            flag = true;
            break;    
        end
    end 
end


