
function playgroundNewLayer = possiblePlaygrounds(playgroundLayer,color)
    cnt = 0;
    
    for l = 1: size(playgroundLayer,2)

        currentNodes = playgroundLayer{l};

        for i=1:size(currentNodes,3)

            cnt = cnt + 1;
            currentNode = currentNodes(:,:,i);

        possibilities = fieldDeallocation(currentNode,color);

        if isempty(possibilities)
            playgroundNewLayer{cnt} = currentNode;
        else
        for k=1:size(possibilities,1)

            currentChild = currentNode;
            currentChild(possibilities(k,1),possibilities(k,2)) = color;
            currentChild = flipStones(currentChild, possibilities(k,:),color);
            currentChildren(:,:,k) =currentChild;   
        end
         playgroundNewLayer{cnt} = currentChildren;
        end

        end
    end

end
