
function tree = createTree(playground,color)

    A = playground(:);
    
    % determine number of zeros
    depth = size(find(A==0),1);

    % number of layers to search in
    if depth>25
        variableDepth = 3;
    else                    
        if depth>3
            variableDepth = 5;
        else
            variableDepth = depth;
        end
    end

    for i=1:variableDepth
        % every layer a different color, change every round
        if ~( mod(i,2) )
            if color==1
                color=2;
            else
                color=1;
            end
        end
        if i == 1
            tree{i}= possiblePlaygrounds({playground},color);
        else
            tree{i}=possiblePlaygrounds(tree{i-1},color);
        end

        % xD
        tree = tree;

    end

    return
end

