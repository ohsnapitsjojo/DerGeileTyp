
function returnNeighbor=nextNeighbor(Row,Colum,playgroundEdge,opponentColor)
        
        % Check Neighbors with delta:
        % [-1,1  -1,0 -1,1
        %   0,-1  X    0,1 
        %   1,-1  1,0  1,1]
        % Delta describes the area(indices) around our current selected stone

        delta = [1 1 1 -1 -1 -1 0 0;1 -1 0 1 -1 0 1 -1]';
        
        newVal = delta+ones(8,1)*[Row,Colum];
        
        % Convert n-dimensinal matrix into 1-dimensional vektor and save
        % 1D index into tmp:
        tmp = sub2ind(size(playgroundEdge),newVal(:,1),newVal(:,2));
        
        s=playgroundEdge(tmp);
        
        % Find all opponents around our current stone pos
        opponentPositions=find(s(:)==opponentColor);
        
        returnNeighbor= newVal(opponentPositions,:);
        
        
return  
end

