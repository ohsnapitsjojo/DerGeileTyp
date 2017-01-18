function [costs,index] = minmax_recursive(playground, player, currentlayerplayer, currentlayer, layerdepth)
 
%PLAYER_LAYER_LDEPTH = [currentlayerplayer, currentlayer, layerdepth]
disp(['Cur. Player:  ', num2str(currentlayerplayer), ' \n Cur. Layer:  ', num2str(currentlayer), ' \n Layer Depth:  ', num2str(layerdepth)]);

% last/depest layer reached -> calculate weigth
if layerdepth == currentlayer       % depht limit reached
    size(playground);
    costs = costsVecFunction(playground,currentlayerplayer)   % return the value/costs
    index = -1;
    return
    
    
else
    % determine who's turn is next
    nextplayer = mod(currentlayerplayer + currentlayer + 1, 2)+1
    disp(['nextplayer ', num2str(nextplayer)]);
    
    % determine all possible positions for new stones
    possibleNewStones = fieldDeallocation(playground,currentlayerplayer)
    if currentlayerplayer == player                  % maximise, if it is my turn
        costs = -10000;
        for i = 1:size(possibleNewStones,1)
            tempplayground = playground;
            tempplayground(possibleNewStones(i,1),possibleNewStones(i,2)) = currentlayerplayer;
            tempplayground = flipStones(tempplayground, currentlayerplayer, possibleNewStones(i,:))     % new playground with corresponding stone set
            size(tempplayground)
            disp(['next newStonePosition(',num2str(i),',:): (',num2str(possibleNewStones(i,1)),' ; ',num2str(possibleNewStones(i,2)),' )']);
            childcosts = minmax_recursive(tempplayground, player, nextplayer, currentlayer+1, layerdepth);           % recursive function
            
            if childcosts > costs;
                costs = childcosts;
                index = possibleNewStones(i)
            end            
        end        
    else                            % player == 2 -> minimize
        costs = 10000;
        for i = 1:length(possibleNewStones)
            tempplayground = playground;
            tempplayground(possibleNewStones(i,1),possibleNewStones(i,2)) = currentlayerplayer;
            tempplayground = flipStones(tempplayground, currentlayerplayer, possibleNewStones(i,:))     % new playground with corresponding stone set
            size(tempplayground)
            disp(['next newStonePosition(',num2str(i),',:): (',num2str(possibleNewStones(i,1)),' ; ',num2str(possibleNewStones(i,2)),' )']);
            childcosts = minmax_recursive(tempplayground, player, nextplayer, currentlayer+1, layerdepth);           % recursive function
                        
            if childcosts < costs;
                costs = childcosts;
                index = possibleNewStones(i)
            end            
        end
    end
    return    
end
end
