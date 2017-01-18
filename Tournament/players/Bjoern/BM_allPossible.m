function possible = BM_allPossible( b, color )
    % Gibt eine Liste zurück mit allen Feldern auf die ein Möglicher Zug
    % erfolgen kann
    % Drei Bedinungen sind dazu notwendig: 
    % -Feld ist frei,
    % -Feld grenzt an gegn. Stein
    % -Stein dreht Steine um
    % profile on; profile clear;

    mapIdx = 1:64;

    % Matrix mit freien Felder
    % Matrix mit Feldern, angrenzend an gegn. Steinen

    adjacencyList = mapIdx((conv2(double(b==-color), ones(3), 'same')~= 0) & (b==0));
    flag=BM_checkFlip(b,color,adjacencyList);
    possible=adjacencyList(flag);
    % profile report;
end

