function [ move ] = greedyAgent( b,color,w,mode)
% Greey Agent
% Mode:         'a': Accountability
%               'h': Heueristic
% Note: Accountability Funktioniert generell schlechter

    load('Accountability.mat');
    
    possibleMoves = allPossible(b,color);

    if ~isempty(possibleMoves)
        hVals = [];
        aVals = [];
        for idx = 1:length(possibleMoves)
            b_tmp = simulateMove(b,color,possibleMoves(idx));
            % Accountability Value
            aVal = aMap(possibleMoves(idx));
            % Heueristic Value
            hVal =  w(1)*hCoinParity(b_tmp,color)+w(2)*hMobility(b_tmp,color)+...
                    w(3)*hCornersCaptured(b_tmp,color)+w(4)*hStability(b_tmp,color);
            hVals = [hVals hVal];
            aVals = [aVals aVal];
            
        end
        eval(['[~,id] = max(' mode 'Vals);']);  % Finde Besten Wert
        move = possibleMoves(id);
    else
        move = [];
    end
end

