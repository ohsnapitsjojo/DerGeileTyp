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
% die Plaetze mit einer 2 markiert werden koennen, fuer die wir schon ein 
% Spielfeld erzeugt haben
bWorking = b;
curPossiblePos = 1;
bPossible = zeros(0,0,0);

for i = 1:numel(x)
    % disp(strcat('Bearbeite gegnerischen Stein auf: X:', num2str(x(i)), ' Y:', num2str(y(i))));
    % Gehe jedes Element durch und bestimme hierfuer moegliche Felder
    % Matlab liefertt Index von oben nach unten und von links nach rechts
    for searchWhere = 1:8   % 1 = ueber, 2 = unter, 3 = links, 4 = rechts, 5 = rechtsdrueber, 6 = rechtsdrunter, 7 = linksdrueber, 8 = linksdrunter
        switch searchWhere
            case 1 %ueber
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
            case 5 %rechtsdrueber
                nextX = x(i) + 1;
                nextY = y(i) - 1;
            case 6 %rechtsdrunter
                nextX = x(i) + 1;
                nextY = y(i) + 1;
            case 7 %linksdrueber
                nextX = x(i) - 1;
                nextY = y(i) - 1;
            case 8 %linksdrunter
                nextX = x(i) - 1;
                nextY = y(i) + 1;
        end % end switch
        % ïueberpruefe ob berechnete Position ueberhaupt gueltig ist
        if ~(nextX > 0 && nextX < 9 && nextY > 0 && nextY < 9)
            % Ungueltige Position, naechste Position ueberpruefen
            continue
        end
        
        % ueberpruefe ob zu untersuchendes Feld leer ist
        if b(nextY, nextX) ~= 0
            % nicht leer, weiter machen
            continue
        end
                
        % Das Feld koennte unter Umstaenden zwei Mal als moeglicher Zug gelten
        % - das wollen wir im Sinne der Effizienz vermeiden, also
        % ueberpruefe das
        if bWorking(nextY, nextX) == 2
            % Feld wurde schonmal ueberprueft! Weitermachen
            %disp(strcat('Feld: X: ', num2str(nextX), ' Y: ', num2str(nextY), ' wurde bereits ueberprueft...'))
            continue
        end
        % Jetzt merken wir uns dass wir das Feld schonmal bearbeitet haben
        bWorking(nextY, nextX) = 2;
        
        % zu untersuchendes Feld ist an dieser Stelle leer und grenzt an
        % gegnerischen Spielstein an und ist im Spielfeld
        % --> ueberpruefe ob irgendwo diagonal, horizontal oder vertikal zu
        % diesem Spielfeld einer unserer Steine liegt (muss sein)
        
        % die checksOK-Matrix ist eine 1x8 Matrix und gibt an, in welcher
        % Richtung sich Spielsteine befinden, die wir umdrehen koennen,
        % sodass die Umdrehfunktion das nicht mehr machen braucht
        % weiterhin koennen wir mit any(checksOK) rausfinden ob wir einen
        % gueltigen Zug hatten
        checksOK = false(1, 8);
        for checkWhere = 1:8    % 1 = ueber, 2 = unter, 3 = links, 4 = rechts, 5 = rechtsdrueber, 6 = rechtsdrunter, 7 = linksdrueber, 8 = linksdrunter
            oppStoneDetected = false;
            switch checkWhere
                case 1  % ueber
                    checkX = nextX;
                    for checkY = nextY - 1:-1:1;
                        if b(checkY, checkX) == oppColor
                            % Solange die Felder der Reihe gegnerische Steine enthalten ist das gut
                            oppStoneDetected = true;
                            continue    % Gegnerische Steine sind OK
                        end
                        
                        if b(checkY, checkX) == 0
                            % In der Reihe liegt ploetzlich kein Stein mehr, wir
                            % brauchen aber unsere Farbe, damit wir hier
                            % hinsetzen duerfen, also bleibt validMove false (keine
                            % Aenderung und wir breaken
                            break
                        end
                        
                        if b(checkY, checkX) == color
                            % Hier liegt unser Stein! Wenn davor ein / mehrere
                            % gegnerische Steine lagen waere das eine moegliche
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
                case 5 % rechtsdrueber
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
                case 7 % linksdrueber
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
            % Eigentlich koennten wir hier aus der Loop rausfliegen, wenn
            % wir einmal einen gueltigen Zug haben, aber wir moechten die
            % checksOK-Matrix fertig machen
        end %for checkWhere -- ab hier haben wir die komplette checksOK Matrix
        
        % Wenn irgendein check OK war, ist es ein gueltiger Zug!)
        %disp(strcat('Field X: ', num2str(nextX), ' Y: ', num2str(nextY), ' curPossiblePos: ', num2str(curPossiblePos)))
        %checksOK
        if any(checksOK)
            % TODO: evtl. Speederhoehung durch preallocation des Arrays moeglich
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
for checkWhere = 1:8    % 1 = ueber, 2 = unter, 3 = links, 4 = rechts, 5 = rechtsdrueber, 6 = rechtsdrunter, 7 = linksdrueber, 8 = linksdrunter
    if ~checksOK(checkWhere)
        % Wenn wir in die Richtung nichts unternehmen koennen, dann brauchen
        % wir das gar nicht erst versuchen
        continue;
    end
    
    % Wir brauchen keine Bedenken haben ueber die Spielfeldgrenzen
    % rauszukommen, da ja immer einer unserer Steine die umzudrehende Reihe
    % beenden muss.
    switch checkWhere
        case 1 %ueber
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
        case 5 %rechtsdrueber
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
        case 7 %linksdrueber
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
