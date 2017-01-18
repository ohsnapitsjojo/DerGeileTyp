function outPlayground = flipStones(inPlayground, ownColor, newStonePosition)
    if ownColor == 1
        opponentColor = 2;
    else
        opponentColor = 1;
    end
    
    if size(newStonePosition,2)== 2
    inPlayground
    
    x = newStonePosition(1);
    y = newStonePosition(2);
    flipdirection = [];
    l = 0;
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
    %playgroundEdge=[ [3 3 3 3 3 3 3 3]'  ,playground ,[3 3 3 3 3 3 3 3]' ];
    %playgroundEdge=[ [3 3 3 3 3 3 3 3 3 3]  ;playgroundEdge; [3 3 3 3 3 3 3 3 3 3] ];
    %l=0;
    playgroundEdge = inPlayground;

    % Find Rows and Colums of own stone positions
    %[Row,Colum]=find(playgroundEdge==ownColor);
    
    % set new stone 
    playgroundEdge(x,y) = ownColor;

        % Find Neighborspositionindices from our i-stone
        
        opponent=nextNeighbor(x,y,playgroundEdge,opponentColor);
        opponentPos_Row     = opponent(:,1);
        opponentPos_Colum   = opponent(:,2);

        % Search stones behind oponents stone
        for k=1:size(opponentPos_Row)

            RowDelta    = opponentPos_Row(k)    - x;
            ColumDelta  = opponentPos_Colum(k)  - y;

            RowAbs      = opponentPos_Row(k)    + RowDelta;
            ColumAbs    = opponentPos_Colum(k)  + ColumDelta;

            % jump "on the line" from stone to stone, until empty slot or own stone
            % reached
            while (RowAbs > 0) && (RowAbs < 9) && (ColumAbs > 0) && (ColumAbs < 9) && playgroundEdge(RowAbs,ColumAbs)==opponentColor 
                RowAbs   = RowAbs   + RowDelta;
                ColumAbs = ColumAbs + ColumDelta;
            end

            if (RowAbs > 0) && (RowAbs < 9) && (ColumAbs > 0) && (ColumAbs < 9) && (playgroundEdge(RowAbs,ColumAbs)==ownColor)     % closed block/line exists
                l = l+1;
                flipdirection(l,:)=[opponentPos_Row(k) ,opponentPos_Colum(k)];  % save directions

            end

        end
        
        % now flip the rigth stones
        for k=1:size(flipdirection)

            RowDelta    = flipdirection(k,1)    - x;
            ColumDelta  = flipdirection(k,2)  - y;

            RowAbs      = x    + RowDelta;
            ColumAbs    = y  + ColumDelta;
            playgroundEdge(RowAbs,ColumAbs)= ownColor;

            % jump "on the line" from stone to stone, until empty slot or own stone
            % reached and flip oponent's stones
            while playgroundEdge(RowAbs,ColumAbs)==opponentColor
                RowAbs   = RowAbs   + RowDelta;
                ColumAbs = ColumAbs + ColumDelta;
                playgroundEdge(RowAbs,ColumAbs)= ownColor;
            end

        end

    outPlayground = playgroundEdge;
    else
        outPlayground = inPlayground;
    end
    return
end
