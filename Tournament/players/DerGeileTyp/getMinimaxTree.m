function [ Nodes] = getMinimaxTree( b,color,depth,w)
% Gibt einen Minimax Tree zurück in from eines Structs Nodes
% ParentID: Vater Node index im Nodes Struct
% ChildrenIDs: Inizes der Kinder Nodes
% isLeaf: ist Leaf Node
% Heueristc: Heueristischer Wert
% Move: Zug um von Parent zu Node zu kommen
% b: Spielbrett nach ausführen von move
% Visited: Besucht oder Nicht
% Color: Spieler der am Zug ist
% Depth: Tiefe der Node im Suchbaum
% Type: min oder max Node
% nChildren: Anzahl der Children Nodes
% Moves: Mögliche Züge die von dieser Node aus erfolgen können

% depth - Tiefe des Baums
% w - 4x1 Vektor um die Heueritiken zu Gewichten


    Nodes = struct( 'ParentID',     {},     'ChildrenIDs',  {},     'Move',     {},...
                    'Moves',        {},     'Depth',        {},     'Visited',  {},...
                    'isLeaf',       {},     'Heueristic',   {},     'Type',     {},...
                    'nChildren',    {},     'Color',        {},     'b',        {});
         
    done = false;
    opponent = -1*color;
    
    % Initialisiere Root Node
    Nodes(1).ParentID = 0;      % Hat kein Parent
    Nodes(1).ChildrenIDs = [];  % Hat noch keine Children
    Nodes(1).Move = [];
    Nodes(1).b = b;
    Nodes(1).Depth = 1;
    Nodes(1).Visited = false;
    Nodes(1).isLeaf = false;
    Nodes(1).Heueristic = [];
    Nodes(1).Type = 'max';
    Nodes(1).Moves = allPossible(b,color);
    Nodes(1).nChildren = length(Nodes(1).Moves);
    Nodes(1).Color = color;

    
    reps = 1;   % Anzahl der bisherigen Wiederholungen
    
    % Es sind weniger Züge vorhanden als die Tiefe des Suchbaums fordert
    maxDepth = 61-getnRounds(b);
    if maxDepth < depth
        depth = maxDepth;
    end

    while ~done
        % Wähle Node aus die noch nicht Visited ist und kein Leaf ist
        if  ~(Nodes(reps).Visited) | ~(Nodes(reps).isLeaf)
            % Nodes(reps) ist Parent
            Nodes(reps).Visited = true;
            Nodes(reps).isLeaf = false;
            
            for idx = 1:Nodes(reps).nChildren
                % Stelle an der die neue Node in Nodes eingefügt wird
                nNodes = length(Nodes)+1;   
                % Aktualisiere Children der Parent Node
                Nodes(reps).ChildrenIDs = [Nodes(reps).ChildrenIDs nNodes]; %TODO Dynamische Liste ändern
                % Setzt Parameter in neue Child Node "Nodes(nNodes)" ein
                Nodes(nNodes).ParentID = reps;
                Nodes(nNodes).Color = -1*Nodes(reps).Color;
                Nodes(nNodes).Move = Nodes(reps).Moves(idx);
                Nodes(nNodes).b = simulateMove(Nodes(reps).b,Nodes(reps).Color,Nodes(nNodes).Move);
                Nodes(nNodes).Depth = Nodes(reps).Depth+1;
                Nodes(nNodes).Visited = false;
                Nodes(nNodes).Moves = allPossible(Nodes(nNodes).b,Nodes(nNodes).Color);
                
                if Nodes(nNodes).Color == opponent
                    Nodes(nNodes).Type = 'min';
                else
                    Nodes(nNodes).Type = 'max';
                end
                % Node ist Leaf Node
                if Nodes(nNodes).Depth == depth
                    Nodes(nNodes).isLeaf = true;
                    Nodes(nNodes).Heueristic = w(1)* hCoinParity(Nodes(nNodes).b,Nodes(nNodes).Color);
                    Nodes(nNodes).nChildren = 0;     % Leafs haben keine Children
                % Node ist kein Leaf Node
                else
                    Nodes(nNodes).isLeaf = false;
                    Nodes(nNodes).Heueristic = [];
                    Nodes(nNodes).nChildren = length(Nodes(nNodes).Moves);
                end  
            end    
        end
        % Fertig wenn alle Visited oder Leafs sind
        visited = [Nodes.Visited];
        leafes = [Nodes.isLeaf];
        if visited | leafes
            done = true;
        end

        reps = reps + 1;
    end
end

