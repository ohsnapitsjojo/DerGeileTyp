function [ move] = forceAvoid(b,color,possible,move)

    try
        Avoid = move == 10 | move == 15| move == 50 | move == 55;
        if Avoid  
        % Avoid Close Corners
            isAvoid = possible == 10 | possible == 15| possible == 50 | possible == 55;
            % Gibt alle Z�ge zur�ck die genehmigt sind
            moves = possible(~isAvoid);
            nMoves = length(moves);
            % Falls keine alternative Z�ge vorhanden sind
            if nMoves == 0
                return;
            end 
            % W�hle Zug der die beste heuersitic bringt
            nStable = zeros(1,nMoves);
            for idx = 1:nMoves
                nStable(idx) = getHeuristic(simulateMove(b,color,moves(idx)),[0 1 0 1],color);
                % KRITERIUM KANN VER�NDERT WERDEN
            end
            [~,id] = max(nStable);
            move = moves(id);
            disp('ECKZUG UMGANGEN!');
        end
    catch ME
        warning(ME.message);
        warning('Ein Fehler ist in forceAvoid aufgetreten, f�hre Minimax Zug aus!');
    end
end


