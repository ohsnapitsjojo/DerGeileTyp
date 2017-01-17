function [ nStable ] = G4_getnStable( b,color )
% Gibt die Anzahl der stabilen Steine der Farbe color zurück
    stabilityBoard = zeros(8,8);
    %Corner 1
    if b(1,1) == color
        % maximale stabile spalte basierend auf stabilen steinen in der reihe
        maxScol = 7;        
        for row = 1:7
            for col = 1:maxScol
                if b(row,col) == color
                    % Steine die an stabile Steine angrenzen sind auch hier
                    % stabil
                    stabilityBoard(row,col) = 1;
                else
                    % Spalte muss nicht weiter untersuchter werden weil kein
                    % stabiler Stein gefunden wurde
                    maxScol = col -1;
                    break;
                end
            end
        end
        maxSrow = 7;
        for col = 1:7
            for row = 1:maxSrow
                if b(row,col) == color
                    stabilityBoard(row,col) = 1;
                else
                    maxSrow = row-1;
                    break;
                end
            end
        end
    end
    %Corner 2
    if b(8,1) == color
        maxScol = 7;           
        for row = 8:-1:2
            for col = 1:maxScol
                if b(row,col) == color
                    stabilityBoard(row,col) = 1;                
                else
                    maxScol = col-1;
                    break;
                end
            end
        end
        maxSrow = 2;           
        for col = 1:7
            for row = 8:-1:maxSrow
                if b(row,col) == color
                    stabilityBoard(row,col) = 1;                
                else
                    maxSrow = row+1;
                    break;
                end
            end
        end
    end 
    %Corner 3
    if b(1,8) == color
        maxScol = 2;           
        for row = 1:7
            for col = 8:-1:maxScol
                if b(row,col) == color
                    stabilityBoard(row,col) = 1;                
                else
                    maxScol = col+1;
                    break;
                end
            end
        end
        maxSrow = 7;           
        for col = 8:-1:2
            for row = 1:maxSrow
                if b(row,col) == color
                    stabilityBoard(row,col) = 1;                
                else
                    maxSrow = row-1;
                    break;
                end
            end
        end
    end 
    %Corner 4
    if b(8,8) == color
        maxScol = 2;           
        for row = 8:-1:2
            for col = 8:-1:maxScol
                if b(row,col) == color
                    stabilityBoard(row,col) = 1;                
                else
                    maxScol = col+1;
                    break;
                end
            end
        end
        maxSrow = 2;           
        for col = 8:-1:2
            for row = 8:-1:maxSrow
                if b(row,col) == color
                    stabilityBoard(row,col) = 1;                
                else
                    maxSrow = row+1;
                    break;
                end
            end
        end
    end
    % Anzahl Stabiler Steine
    nStable = sum(stabilityBoard(:));
end

