function [ move] = forceAvoid(b,color,possible,move)

    try
        
        Avoid = [move == 10  move == 15 move == 50  move == 55];
        openCorners = [b(1,1) == 0, b(8,1) == 0, b(1,8) == 0 , b(8,8) == 0];
        if any(Avoid & openCorners)  
        % Avoid Close Corners
            closeCorners = [10,15,50,55];
            avoidMoves = closeCorners(openCorners);
            % Alle close Corners zu freien Ecken vermeiden
            isAvoid = ismember(possible,avoidMoves);
            % Gibt alle Züge zurück die genehmigt sind
            moves = possible(~isAvoid);
            nMoves = length(moves);
            % Falls keine alternative Züge vorhanden sind
            if nMoves == 0
                return;
            end 
            % Wähle Zug der die beste heuersitic bringt
            nStable = zeros(1,nMoves);
            for idx = 1:nMoves
                nStable(idx) = getHeuristic(simulateMove(b,color,moves(idx)),[0 1 0 1],color);
                % KRITERIUM KANN VERÄNDERT WERDEN
            end
            [~,id] = max(nStable);
            move = moves(id);
            disp('ECKZUG UMGANGEN!');
        end
    catch ME
        warning(ME.message);
        warning('Ein Fehler ist in forceAvoid aufgetreten, führe Minimax Zug aus!');
    end
end


