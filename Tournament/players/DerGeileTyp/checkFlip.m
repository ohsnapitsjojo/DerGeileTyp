function [flag] = checkFlip(b, color, move )
% Diese Funktion Überprüft ob beim setzene eines Steins auf move ein
% gegnerischer Stein geflippt wird

    directions = {[0,-1] [1,1] [0,1] [1,-1] [-1,0] [-1,-1] [1, 0] [-1,1]};  % Mögliche 8 Richtungen 
    flag = false(1,length(move));
    for id = 1:length(move)
    b(id) = color;    % Spielbrett aktualiesieren
    
    for idx = 1:8
        if checkFlipDirection(b,color,move(id),directions{idx}) % Alle Richtungen werden ausprobiert
            flag(id) = true;
            break;
        end
    end
    end
end

