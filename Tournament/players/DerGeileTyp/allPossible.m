function possible = allPossible( b, color )
% Gibt eine Liste zurück mit allen Feldern auf die ein Möglicher Zug
% erfolgen kann
% Drei Bedinungen sind dazu notwendig: 
% -Feld ist frei,
% -Feld grenzt an gegn. Stein
% -Stein dreht Steine um

eColor = -color;
kernel1 = ones(3,3);



% Matrix mit freien Felder
emptyFields = b==0;

% Matrix mit Feldern, angrenzend an gegn. Steinen
enemyFields = double(b==eColor);
adjacentFields = conv2(enemyFields, kernel1, 'same');
adjacentFields = adjacentFields ~= 0;

adjacencyList = find(adjacentFields == emptyFields);

possible= [];

n = size(find(adjacencyList),1)
    for idx = 1:n
        move = adjacencyList(idx);
        if checkFlip(b,color,move)
            possible = [possible, move];    % Ein Stein darf an Position move gelegt werden
        end   
    end
end

