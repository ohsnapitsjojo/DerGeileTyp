function [adjacencyList, len] = getAdjacencyList( b,color )
% Gibt eine Liste zurück mit Feldern die frei sind und an gegnerische
% Steine angrenzen
    opponent = -1*(color);
    
    bpad = zeros(10);
    bpad(2:9,2:9) = b;
    
    adjacencyList = [];
    listElement = 1;
    len = 0;
    
    for idx = 2:9
        for jdx = 2:9
            patch = bpad(jdx-1:jdx+1,idx-1:idx+1);
            patch(2,2) = 0;
            if logical(find(patch == opponent)) & bpad(jdx,idx) == 0
                adjacencyList = [adjacencyList, listElement];
                len = len + 1;
            end
            listElement = listElement + 1;
        end
    end
end

