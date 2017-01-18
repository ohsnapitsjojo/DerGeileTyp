function [bChild, cntPosFound, xFound, yFound] = FindNewChild(b, color, cntPosStart)
%FINDNEWCHILD Summary of this function goes here
%   Detailed explanation goes here

bChild = 0;
xFound = 0;
yFound = 0;
cntPosFound = 0;
change = 0;

% Vorsortierung der Zuege
posOrder = [1,1,8,8,1,1,8,8,3,3,6,6,1,1,8,8,4,4,5,5,3,3,6,6,3,3,6,6,4,4,5,5,2,2,7,7,4,4,5,5,2,2,7,7,3,3,6,6,1,1,8,8,2,2,7,7,2,2,7,7;...
            1,8,1,8,3,6,3,6,1,8,1,8,4,5,4,5,1,8,1,8,3,6,3,6,4,5,4,5,3,6,3,6,4,5,4,5,2,7,2,7,3,6,3,6,2,7,2,7,2,7,2,7,1,8,1,8,2,7,2,7];

if ( cntPosStart > size(posOrder,2) )
    % Beende Funktion
    return
end        
        
% Alle Positionen (x,y) von (xChild,yChild) an durchgehen
for cntPos = cntPosStart:size(posOrder,2)
    x=posOrder(1,cntPos);
    y=posOrder(2,cntPos);

    % Falls Feld noch frei ist...
    if b(x,y) == 0;
        % Alle Richtungen durchgehen
        for dx = -1:1
            for dy = -1:1
                dist = 1;
                posx = x + (dist * dx);
                posy = y + (dist * dy);

                % Der naechste Nachbar MUSS dann die Gegenfarbe sein.
                % Ausserdem darf man nicht ausserhalb sein
                if(posx~=0 && posx~=9 && posy~=0 && posy~=9 && b(posx,posy)==-color)

                    % Danach muss irgendwann wieder der eigene Stein
                    % kommen...
                    for dist = 2:7
                        posx = x + (dist * dx);
                        posy = y + (dist * dy);

                        % Es darf KEIN leeres Feld kommen
                        if(posx<1 || posx>8 || posy<1 || posy>8 || b(posx,posy)==0)
                            break % terminate 'for dist=2:7'
                        end

                        % Falls wieder auf die eigene Farbe getroffen
                        % wird, ist ein ZUG MOEGLICH. Nun flippe sofort
                        % die Steine.
                        if (b(posx,posy) == color)
                            % display(['Gefunden: (' num2str(x) ',' num2str(y) ') mit dx=' num2str(dx) ' und dy= ' num2str(dy) ' und dist=' num2str(dist)])
                            if (change == 0)
                                bChild = b;
                            end
                            change = 1;

                            % Steine Flippen
                            for dist2 = 0:dist-1
                                posx = x + (dist2 * dx);
                                posy = y + (dist2 * dy);
                                bChild(posx,posy) = color;
                            end
                            break % terminate 'for dist=2:7'
                        end

                    end
                end
            end
        end
    end

    % Eine Position wurde gefunden, also soll jetzt die Funktion mit
    % den Rückgabewerten beendet werden
    if (change == 1)
        xFound = x;
        yFound = y;
        cntPosFound = cntPos;
        return % BEENDE Funktion!
    end
end

end