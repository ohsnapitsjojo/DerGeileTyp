function [ move ] = minimaxAgent( b, color, depth, w)
% Berechnet den move eines Minimax Agenten

    possibleMoves = allPossible(b,color);
    
    if ~isempty(possibleMoves) 
        %Nodes = getMinimaxTree(b,color,depth,w);
        % move = minimaSearch(Nodes) --> % TODO implemen
        move = alphaBeta(b,color,depth,w);
    else
        move = [];
    end

end


