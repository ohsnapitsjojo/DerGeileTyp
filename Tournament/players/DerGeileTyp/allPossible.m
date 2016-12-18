function possible = allPossible( b, color )
% Gibt eine Liste zurück mit allen Feldern auf die ein Möglicher Zug
% erfolgen kann
% Drei Bedinungen sind dazu notwendig: 
% -Feld ist frei,
% -Feld grenzt an gegn. Stein
% -Stein dreht Steine um
tic;

% Matrix mit freien Felder

% Matrix mit Feldern, angrenzend an gegn. Steinen
[x1,y1] = find(conv2(double(b==-color), ones(3), 'same') ~= 0 & b==0);
possible= [];


    for idx = 1:size(x1)
        move = [x1(idx),y1(idx)];
        if checkFlip(b,color,move)
            possible = [possible; move];    % Ein Stein darf an Position move gelegt werden
        end   
    end
    toc;
end

