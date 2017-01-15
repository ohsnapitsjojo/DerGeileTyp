function [ move, minimax ] = forceMoves( b, color, possible)
% Diese funktion beinhalte Force Moves die h�here Priorit�t als ein Minimax
% Zug Haben:
% 1) Stein in die Ecke legen wenn sie Frei ist
% 2) Stein niemals vor ein Ecke legen wenn m�glich
% Move gibt entweder den Force Corner Zug Zur�ck, oder eine Liste ohne
% Close Corner Z�ge
    try
        move = [];
        % Nachschauen ob Corners frei sind
        isCorner = possible == 1 | possible == 8 | possible == 57 | possible == 64;
        isAvoid = possible == 10 | possible == 15| possible == 50 | possible == 55;
        if any(isCorner)
        % Force Corners
            minimax = false;
            move = possible(isCorner);
            % Falls mehr als ein Corner m�glich ist
            nMoves = length(move);
            if nMoves > 1
                nStable = zeros(1,nMoves);
                for idx = 1:nMoves
                    nStable(idx) = getnStable(simulateMove(b,color,move(idx)),color);
                end
                % W�hle Zug der die meisten Stabilen Steine erzeugt
                [~,id] = max(nStable);
                move = move(id);
            end
        elseif any(isAvoid) && ~any(isCorner)
        % Avoid Close Corners
            % Gibt alle Z�ge zur�ck die genehmigt sind
            minimax = true;
            move = possible(~isAvoid);
            % Falls kein Z�ge m�glich sind ohne nahe an Ecken zu setzen
            nMoves = length(move);
            if nMoves == 0
                minimax = false;
                move = possible;
                nStable = zeros(1,nMoves);
                for idx = 1:nMoves
                    nStable(idx) = getnStable(simulateMove(b,color,move(idx)),color);
                end
                % W�hle Zug der die meisten Stabilen Steine erzeugt
                [~,id] = max(nStable);
                move = move(id);
            end
        end
    catch ME
        warning(ME.message);
        warning('Ein Fehler ist is forceMoves aufgetreten, f�hre Minimax Zug aus!');
        move = [];
        minimax = true;
    end
end

