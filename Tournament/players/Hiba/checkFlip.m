function [flag] = checkFlip(b, color, adjacencyList )
% Diese Funktion Überprüft ob beim setzene eines Steins auf move ein
% gegnerischer Stein geflippt wird

    directions = {[0,-1] [1,1] [0,1] [1,-1] [-1,0] [-1,-1] [1, 0] [-1,1]};  % Mögliche 8 Richtungen
    len = length(adjacencyList);
    flag = false(1,len);
    for id = 1:len
        for idx = 1:8
            if checkFlipDirection(b,color,adjacencyList(id),directions{idx}) % Alle Richtungen werden ausprobiert
                flag(id) = true;
                break;
            end
        end
    end
end

