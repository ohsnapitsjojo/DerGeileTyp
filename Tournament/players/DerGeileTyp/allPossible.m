function possible = allPossible( b, color )
% Gibt eine Liste zurück mit allen Feldern auf die ein Möglicher Zug
% erfolgen kann
    possible = [];
    [adjacencyList, len] = getAdjacencyList(b,color); % Alle Positionen an die ein Gegner angrenzt und die frei sind
    for idx = 1:len
        move = adjacencyList(idx);
        if checkFlip(b,color,move)
            possible = [possible, move];    % Ein Stein darf an Position move gelegt werden
        end   
    end
end

