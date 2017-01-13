function [count] = NumFlips(b,color,x,y)
%NUMFLIPS Summary of this function goes here
%   Gibt die Anzahl der flippenden Steine zurück
directions = [1  0;... % rechts
             -1  0;... % links
              0  1;... % unten
              0 -1;... % oben
             -1 -1;... % links-oben
              1 -1;... % rechts-oben
             -1  1;... % links-unten
              1  1];   % rechts-unten

dist = 1;
posx = 1;
posy = 1;
count = 0;

% richtungsvektor benutzen
for direction_nr = 1:8
    % maximale anzahl einer reihe
    for dist = 1:8
        posx = x + (dist * directions(direction_nr,1));
        posy = y + (dist * directions(direction_nr,2));
        % stoppen - aus dem feld gelaufen
        if(posx < 1 || posx > 8 || posy < 1 || posy > 8)
            break;
        end
        % stoppen - leeres feld
        if(b(posx,posy) == 0)
            break;
        end
        % dazugehoeriges feld gefunden - zusaetzliche steine zu count
        % addieren
        if (b(posx,posy) == color)
            count = count + dist - 1;
            % innerste schleife beenden
            break;
        end
    end
end

end

