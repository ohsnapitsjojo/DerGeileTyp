function [ v, m ] = alphaBetaPruning( b, depth, alpha, beta, color, turn, w, toplayer )
%ALPHABETAPRUNING Summary of this function goes here
%   Detailed explanation goes here
    m = -1;
    possMoves = allPossible(b, turn);
    nMoves = length(possMoves);

    if depth == 0 || nMoves == 0
        v =(w(1)* hCoinParity(b,turn));
        return 
    end

    if turn == color
       v = -inf;

       for k=1:nMoves
           bNew = simulateMove(b, turn, possMoves(k));
           [vNew, ~] = alphaBetaPruning(bNew, depth-1, alpha, beta, color, turn*-1, w, false);
           v = max(v, vNew);
           if alpha < v
              alpha = v;
              if toplayer == true
                m = possMoves(k);
              end
           end

           if beta <= alpha
              break;
           end

           return
       end
       
    else
        v = inf;
        
        for k=1:nMoves
           bNew = simulateMove(b, turn, possMoves(k));
           [vNew, ~] = alphaBetaPruning(bNew, depth-1, alpha, beta, color, turn*-1, w, false);
           v = min(v, vNew);
           if beta > v
              beta = v;
              if toplayer == true
                m = possMoves(k);
              end
    
           end

           if beta <= alpha
              break;
           end

           return
       end
    end
    
    

    
end

