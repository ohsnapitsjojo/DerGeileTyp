%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fieldDeallocation
% shall say, on which fields it is allowed to set stones at all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%spi


function gameMatrix2 = fieldDeallocation(playground,ownColor)
    if ownColor == 1
        opponentColor = 2;
    else
        opponentColor = 1;
    end
    gameMatrix = [];
    %
    %playgroundEdge looks like that:
    %[3 3 3 3 3 3 3 3 3 3
    % 3                 3
    % 3                 3
    % 3                 3
    % 3   Playground    3
    % 3                 3
    % 3                 3
    % 3                 3
    % 3 3 3 3 3 3 3 3 3 3]
    playgroundEdge=[ [3 3 3 3 3 3 3 3]'  ,playground ,[3 3 3 3 3 3 3 3]' ];
    playgroundEdge=[ [3 3 3 3 3 3 3 3 3 3]  ;playgroundEdge; [3 3 3 3 3 3 3 3 3 3] ];
    l=0;

    % Find Rows and Colums of own stone positions
    [Row,Colum]=find(playgroundEdge==ownColor);
    for i=1:size(Row)
    
        % Find Neighborspositionindices from our i-stone
        
        opponent=nextNeighbor(Row(i),Colum(i),playgroundEdge,opponentColor);
        opponentPos_Row     = opponent(:,1);
        opponentPos_Colum   = opponent(:,2);

        % Search stones behind oponents stone to 
        for k=1:size(opponentPos_Row)

            RowDelta    = opponentPos_Row(k)    - Row(i);
            ColumDelta  = opponentPos_Colum(k)  - Colum(i);

            RowAbs      = opponentPos_Row(k)    + RowDelta;
            ColumAbs    = opponentPos_Colum(k)  + ColumDelta;

            % jump "on the line" from stone to stone, until empty slot or own stone
            % reached
            while playgroundEdge(RowAbs,ColumAbs)==opponentColor
                RowAbs   = RowAbs   + RowDelta;
                ColumAbs = ColumAbs + ColumDelta;
            end

            if (playgroundEdge(RowAbs,ColumAbs)==0)     % possible position für new stone
                l = l+1;
                gameMatrix(l,:)=[RowAbs-1,ColumAbs-1];  % save possible new positions

            end

        end

    end
    if ~isempty(gameMatrix)
        hodi = sub2ind(size(playgroundEdge),gameMatrix(:,1),gameMatrix(:,2));
        
        %unique gives back all kinds of values and sorts them into a vector
        hasselhoff = unique(hodi);
        
        
        [him,her]=ind2sub(size(playgroundEdge),hasselhoff);
        gameMatrix2=[him,her];
    else
        gameMatrix2 = [];
    end
    return
end
