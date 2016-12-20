function [ move ] = minimaxAgent( b, color, depth, w)
% Berechnet den move eines Minimax Agenten
% TODO: NOCH NICHT FERTIG 

    possibleMoves = allPossible(b,color);
    
    if ~isempty(possibleMoves)
        
        Nodes = getMinimaxTree(b,color,depth,w);
        move = [];
        % move = minimaSearch(Nodes) --> % TODO implement

    else
        move = [];
    end

end


