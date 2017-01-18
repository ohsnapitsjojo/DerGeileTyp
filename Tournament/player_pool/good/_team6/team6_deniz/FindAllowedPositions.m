function [bPossible] = FindAllowedPositions(b, color)

% Bestimme gegnerische Spielerfarbe (wir: color, Gegner: oppColor)
if color == 1
    oppColor = -1;
else
    oppColor = 1;
end

% Finde alle Elemente (x,y-Positionen) wo ein gegnerischer Stein steht
[y,x] = find(b == oppColor);

% Kopie des Spielfelds in bWorking anlegen, damit in bWorking
% die Pl�tze mit einer 2 markieren werden k�nnen, f�r die wir schon ein Spielfeld
% erzeugt haben
bWorking = b;
curPossiblePos = 1;
bPossible = zeros(0,0,0);

for i = 1:numel(x)
    %disp(strcat('Bearbeite gegnerischen Stein auf: X:', num2str(x(i)), ' Y:', num2str(y(i))));
    % Gehe jedes Element durch und bestimme hierf�r m�gliche Felder
    % Matlab lie�t Index von oben nach unten und von links nach rechts
    for searchWhere = 1:8   % 1 = �ber, 2 = unter, 3 = links, 4 = rechts, 5 = rechtsdr�ber, 6 = rechtsdrunter, 7 = linksdr�ber, 8 = linksdrunter
        switch searchWhere
            case 1 %�ber
                nextX = x(i);
                nextY = y(i) - 1;
            case 2 %unter
                nextX = x(i);
                nextY = y(i) + 1;
            case 3 %links
                nextX = x(i) - 1;
                nextY = y(i);
            case 4 %rechts
                nextX = x(i) + 1;
                nextY = y(i);
            case 5 %rechtsdr�ber
                nextX = x(i) + 1;
                nextY = y(i) - 1;
            case 6 %rechtsdrunter
                nextX = x(i) + 1;
                nextY = y(i) + 1;
            case 7 %linksdr�ber
                nextX = x(i) - 1;
                nextY = y(i) - 1;
            case 8 %linksdrunter
                nextX = x(i) - 1;
                nextY = y(i) + 1;
        end % end switch
        % �berpr�fe ob berechnete Position �berhaupt g�ltig ist
        if ~(nextX > 0 && nextX < 9 && nextY > 0 && nextY < 9)
            % Ung�ltige Position, n�chste Position �berpr�fen
            continue
        end
        
        % �berpr�fe ob zu untersuchendes Feld leer ist
        if b(nextY, nextX) ~= 0
            % nicht leer, weiter machen
            continue
        end
                
        % Das Feld k�nnte unter umst�nden zwei Mal als m�glicher Zug gelten
        % - das wollen wir im Sinne der Effizienz vermeiden, also �berpr�fe
        % das
        if bWorking(nextY, nextX) == 2
            % Feld wurde schonmal �berpr�ft! Weitermachen
            %disp(strcat('Feld: X: ', num2str(nextX), ' Y: ', num2str(nextY), ' wurde bereits �berpr�ft...'))
            continue
        end
        % Jetzt merken wir uns dass wir das Feld schonmal bearbeitet haben
        bWorking(nextY, nextX) = 2;
        
        % zu untersuchendes Feld ist an dieser Stelle leer und grenzt an
        % gegnerischen Spielstein an und ist im Spielfeld
        % --> �berpr�fe ob irgendwo diagonal, horizontal oder vertikal zu
        % diesem Spielfeld einer unserer Steine liegt (muss sein)
        
        % die checksOK-Matrix ist eine 1x8 Matrix und gibt an, in welcher
        % Richtung sich Spielsteine befinden, die wir umdrehen k�nnen,
        % sodass die Umdrehfunktion das nicht mehr machen braucht
        % weiterhin k�nnen wir mit any(checksOK) rausfinden ob wir einen
        % g�ltigen Zug hatten
        checksOK = false(1, 8);
        for checkWhere = 1:8    % 1 = �ber, 2 = unter, 3 = links, 4 = rechts, 5 = rechtsdr�ber, 6 = rechtsdrunter, 7 = linksdr�ber, 8 = linksdrunter
            oppStoneDetected = false;
            switch checkWhere
                case 1  % �ber
                    checkX = nextX;
                    for checkY = nextY - 1:-1:1;
                        if b(checkY, checkX) == oppColor
                            % Solange die Felder der Reihe gegnerische Steine enthalten ist das gut
                            oppStoneDetected = true;
                            continue    % Gegnerische Steine sind OK
                        end
                        
                        if b(checkY, checkX) == 0
                            % In der Reihe liegt pl�tzlich kein Stein mehr, wir
                            % brauchen aber unsere Farbe, damit wir hier hin
                            % setzen d�rfen, also bleibt validMove false (keine
                            % �nderung und wir breaken
                            break
                        end
                        
                        if b(checkY, checkX) == color
                            % Hier liegt unser Stein! Wenn davor ein / mehrere
                            % gegnerische Steine lagen w�re das eine m�gliche
                            % Position
                            if (oppStoneDetected)
                                checksOK(1) = true;
                                break  % gar nicht mehr weiterschauen
                            else
                                % Wir hatten aber keine gegnerischen Steine
                                % vorher also ist das keine Option
                                break
                            end
                        end
                    end % end for checkY
                case 2 % unter
                    checkX = nextX;
                    for checkY = nextY + 1:8
                        if b(checkY, checkX) == oppColor
                            oppStoneDetected = true;
                            continue
                        end
                        
                        if b(checkY, checkX) == 0
                            break
                        end
                        
                        if b(checkY, checkX) == color
                            if (oppStoneDetected)
                                checksOK(2) = true;
                                break
                            else
                                break
                            end
                        end
                    end % end for Reihe runtergehen
                case 3 % links
                    checkY = nextY;
                    for checkX = checkX - 1:-1:1
                        if b(checkY, checkX) == oppColor
                            oppStoneDetected = true;
                            continue
                        end
                        
                        if b(checkY, checkX) == 0
                            break
                        end
                        
                        if b(checkY, checkX) == color
                            if (oppStoneDetected)
                                checksOK(3) = true;
                                break
                            else
                                break
                            end
                        end
                    end % end for Reihe nach links checken
                case 4 % rechts
                    checkY = nextY;
                    for checkX = nextX + 1:8
                        if b(checkY, checkX) == oppColor
                            oppStoneDetected = true;
                            continue
                        end
                        
                        if b(checkY, checkX) == 0
                            break
                        end
                        
                        if b(checkY, checkX) == color
                            if (oppStoneDetected)
                                checksOK(4) = true;
                                break
                            else
                                break
                            end
                        end
                    end % end for Reihe nach rechts checken
                case 5 % rechtsdr�ber
                    checkY = nextY;
                    checkX = nextX;
                    for curIter = max(9 - nextY, nextX):7
                        checkY = checkY - 1;
                        checkX = checkX + 1;
                        if b(checkY, checkX) == oppColor
                            oppStoneDetected = true;
                            continue
                        end
                        
                        if b(checkY, checkX) == 0
                            break
                        end
                        
                        if b(checkY, checkX) == color
                            if (oppStoneDetected)
                                checksOK(5) = true;
                                break
                            else
                                break
                            end
                        end
                    end % end for Reihe nach rechtsoben checken
                case 6 % rechtsdrunter
                    checkY = nextY;
                    checkX = nextX;
                    for curIter = max(nextY, nextX):7
                        checkY = checkY + 1;
                        checkX = checkX + 1;
                        if b(checkY, checkX) == oppColor
                            oppStoneDetected = true;
                            continue
                        end
                        
                        if b(checkY, checkX) == 0
                            break
                        end
                        
                        if b(checkY, checkX) == color
                            if (oppStoneDetected)
                                checksOK(6) = true;
                                break
                            else
                                break
                            end
                        end
                    end % end for Reihe nach rechtsdrunter checken
                case 7 % linksdr�ber
                    checkY = nextY;
                    checkX = nextX;
                    for curIter = max(9 - nextY, 9 - nextX):7
                        checkY = checkY - 1;
                        checkX = checkX - 1;
                        if b(checkY, checkX) == oppColor
                            oppStoneDetected = true;
                            continue
                        end
                        
                        if b(checkY, checkX) == 0
                            break
                        end
                        
                        if b(checkY, checkX) == color
                            if (oppStoneDetected)
                                checksOK(7) = true;
                                break
                            else
                                break
                            end
                        end
                    end
                case 8 % linksdrunter
                    checkY = nextY;
                    checkX = nextX;
                    for curIter = max(nextY, 9 - nextX):7
                        checkY = checkY + 1;
                        checkX = checkX - 1;
                        if b(checkY, checkX) == oppColor
                            oppStoneDetected = true;
                            continue
                        end
                        
                        if b(checkY, checkX) == 0
                            break
                        end
                        
                        if b(checkY, checkX) == color
                            if (oppStoneDetected)
                                checksOK(8) = true;
                                break
                            else
                                break
                            end
                        end
                    end
            end %switch
            % Eigentlich k�nnten wir hier aus der Loop rausfliegen, wenn
            % wir einmal einen g�ltigen Zug haben, aber wir m�chten die
            % checksOK-Matrix fertig machen
        end %for checkWhere -- ab hier haben wir die komplette checksOK Matrix
        
        % Wenn irgendein check OK war, ist es ein g�ltiger Zug!)
        %disp(strcat('Field X: ', num2str(nextX), ' Y: ', num2str(nextY), ' curPossiblePos: ', num2str(curPossiblePos)))
        %checksOK
        if any(checksOK)
            % TODO: evtl. Speederh�hung durch preallocation des Arrays m�glich
            bPossible(:,:,curPossiblePos) = turnStones(b, nextX, nextY, checksOK, color, oppColor);
            curPossiblePos = curPossiblePos + 1;
        end
    end % end for searchWhere
end % end for durch jeden gegnerischen Stein iterieren
if isempty(bPossible)
    %disp('Keine Spielzuege moeglich!')
    bPossible(:,:,1) = b;
end

function [bOut] = turnStones(b, x, y, checksOK, color, oppColor)
% Hier wird angenommen wir setzen auf x,y und drehen entsprechend alle
% Steine um
bOut = b;
bOut(y,x) = color;  % Wir setzen unseren Stein da hin
for checkWhere = 1:8    % 1 = �ber, 2 = unter, 3 = links, 4 = rechts, 5 = rechtsdr�ber, 6 = rechtsdrunter, 7 = linksdr�ber, 8 = linksdrunter
    if ~checksOK(checkWhere)
        % Wenn wir in die Richtung nichts unternehmen k�nnen, dann brauchen
        % wir das gar nicht erst versuchen
        continue;
    end
    
    % Wir brauchen keine Bedenken haben �ber die Spielfeldgrenzen
    % rauszukommen, da ja immer einer unserer Steine die umzudrehende Reihe
    % beenden muss.
    switch checkWhere
        case 1 %�ber
            checkX = x;
            checkY = y - 1;
            while b(checkY, checkX) == oppColor
                bOut(checkY, checkX) = color;
                checkY = checkY - 1;
            end
        case 2 %unter
            checkX = x;
            checkY = y + 1;
            while b(checkY, checkX) == oppColor
                bOut(checkY, checkX) = color;
                checkY = checkY + 1;
            end
        case 3 %links
            checkX = x - 1;
            checkY = y;
            while b(checkY, checkX) == oppColor
                bOut(checkY, checkX) = color;
                checkX = checkX - 1;
            end
        case 4 %rechts
            checkX = x + 1;
            checkY = y;
            while b(checkY, checkX) == oppColor
                bOut(checkY, checkX) = color;
                checkX = checkX + 1;
            end
        case 5 %rechtsdr�ber
            checkX = x + 1;
            checkY = y - 1;
            while b(checkY, checkX) == oppColor
                bOut(checkY, checkX) = color;
                checkX = checkX + 1;
                checkY = checkY - 1;
            end
        case 6 %rechtsdrunter
            checkX = x + 1;
            checkY = y + 1;
            while b(checkY, checkX) == oppColor
                bOut(checkY, checkX) = color;
                checkX = checkX + 1;
                checkY = checkY + 1;
            end
        case 7 %linksdr�ber
            checkX = x - 1;
            checkY = y - 1;
            while b(checkY, checkX) == oppColor
                bOut(checkY, checkX) = color;
                checkX = checkX - 1;
                checkY = checkY - 1;
            end
        case 8 %linksdrunter
            checkX = x - 1;
            checkY = y + 1;
            while b(checkY, checkX) == oppColor
                bOut(checkY, checkX) = color;
                checkX = checkX - 1;
                checkY = checkY + 1;
            end
    end %end switch checkWhere
end %for checkWhere
