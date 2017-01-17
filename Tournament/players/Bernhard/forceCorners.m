function [ move ] = forceCorners( b , color, possible )
% Forciert eine Zug auf einen Corner
    try
        move = [];
        % Nachschauen ob Corners frei sind
        isCorner = possible == 1 | possible == 8 | possible == 57 | possible == 64;
        if any(isCorner)
        % Force Corners
            move = possible(isCorner);
            % Falls mehr als ein Corner möglich ist
            nMoves = length(move);
            if nMoves > 1
                nStable = zeros(1,nMoves);
                for idx = 1:nMoves
                    nStable(idx) = getnStable(simulateMove(b,color,move(idx)),color);
                end
                % Wähle Zug der die meisten Stabilen Steine erzeugt
                [~,id] = max(nStable);
                move = move(id);
            end
            disp('ECKE FORCIERT!');
        end
        
    catch ME
        warning(ME.message);
        warning('Ein Fehler ist is forceCorner aufgetreten, führe Minimax Zug aus!');
        move = [];
    end
end

