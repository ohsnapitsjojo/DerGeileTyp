function [flag] = checkFlip(b, color, move )
% Diese Funktion �berpr�ft ob beim setzene eines Steins auf move ein
% gegnerischer Stein geflippt wird
    flag = false;
    b(move) = color;    % Spielbrett aktualiesieren
    directions = {[0,-1] [1,1] [0,1] [1,-1] [-1,0] [-1,-1] [1, 0] [-1,1]};  % M�gliche 8 Richtungen 
    
    for idx = 1:8
        if checkFlipDirection(b,color,move,directions{idx}) % Alle Richtungen werden ausprobiert
            flag = true;
            break;
        end
    end
end

