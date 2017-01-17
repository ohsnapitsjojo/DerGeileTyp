function [ move] = G4_forceAvoid(b,color,possible,move)

    try
        if isempty(move)
            return;
        end
        
        Avoid = [move == 2  move == 9 move == 10  move == 7 ...
                 move == 15   move == 16  move == 49   move == 50 ...
                 move == 58  move == 55 move == 56  move == 63];
     
        openCorners = [ b(1,1) == 0, b(1,1) == 0, b(1,1) == 0,...
                        b(8,1) == 0, b(8,1) == 0, b(8,1) == 0,...
                        b(1,8) == 0, b(1,8) == 0, b(1,8) == 0,...
                        b(8,8) == 0, b(8,8) == 0, b(8,8) == 0];
        if any(Avoid & openCorners)  
        % Avoid Close Corners
            closeCorners = [2,9,10,7,15,16,49,50,58,55,56,63];
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
                nStable(idx) = G4_getHeuristic(G4_simulateMove(b,color,moves(idx)),[0 1 0 1],color);
                % KRITERIUM KANN VERÄNDERT WERDEN
            end
            [~,id] = max(nStable);
            move = moves(id);
        end
    catch ME
        warning(ME.message);
        warning('Ein Fehler ist in forceAvoid aufgetreten, führe Minimax Zug aus!');
    end
end


