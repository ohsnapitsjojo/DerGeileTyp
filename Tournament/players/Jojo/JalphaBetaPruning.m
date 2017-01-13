function [ v, m ] = JalphaBetaPruning( b, depth, alpha, beta, color, turn, w, toplayer )

    m = [];
    possMoves = allPossible(b, turn);
    nMoves = length(possMoves);

    % Wenn Leaf, dann Heuristic zurückgeben
    if depth == 0 || nMoves == 0
        v = JgetHeuristic( b, w, color );
        % TODO: HEURISTIC HIER EINSETZEN
        return 
    end

    % Wenn Max Layer, dann v Werte berechnen und mit Alpha Werte
    % abgleichen. Größerer Wert wird übernommen
    if turn == color
       v = -inf;

       for k=1:nMoves
           bNew = simulateMove(b, turn, possMoves(k));
           [vNew, ~] = JalphaBetaPruning(bNew, depth-1, alpha, beta, color, turn*-1, w, false);
           v = max(v, vNew);
           if alpha < v
              alpha = v;
              if toplayer == true
                % Wenn toplayer und Alpha wert wird upgedatet -> Zug
                % zurückgeben.
                m = possMoves(k);
              end
           end

           if beta <= alpha
               % Ast musst nicht weiter betrachtet werden sobald 
               % beta <= alpha
              break;
           end

       end
       return
    else
        v = inf;
        
        for k=1:nMoves
           bNew = simulateMove(b, turn, possMoves(k));
           [vNew, ~] = JalphaBetaPruning(bNew, depth-1, alpha, beta, color, turn, w, false);
           v = min(v, vNew);
           if beta > v
              beta = v;
              if toplayer == true
                % Wenn toplayer und Beta wert wird upgedatet -> Zug
                % zurückgeben.
                m = possMoves(k);
              end
    
           end

           if beta <= alpha
               % Ast musst nicht weiter betrachtet werden sobald 
               % beta <= alpha
              break;
           end

           
       end
       return
    end
    
    

    
end

