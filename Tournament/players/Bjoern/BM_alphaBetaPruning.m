function [ v, m ] = BM_alphaBetaPruning( b, depth, alpha, beta, color, turn, w, toplayer )

    m = [];
    possMoves = BM_allPossible(b, turn);
    nMoves = length(possMoves);

    % Wenn Leaf, dann Heuristic zur�ckgeben
    if depth == 0|| nMoves== 0
        v = BM_getHeuristic( b, w, color );
        % TODO: HEURISTIC HIER EINSETZEN
        return 
    end

    % Wenn Max Layer, dann v Werte berechnen und mit Alpha Werte
    % abgleichen. Gr��erer Wert wird �bernommen
    if ((turn == color  && nMoves~=0)||(turn== -color && nMoves==0))
       v = -inf;

       for k=1:nMoves
           bNew = BM_simulateMove(b, turn, possMoves(k));
           [vNew, ~] = BM_alphaBetaPruning(bNew, depth-1, alpha, beta, color, turn*-1, w, false);
           v = max(v, vNew);
           if alpha < v
              alpha = v;
              if toplayer == true
                % Wenn toplayer und Alpha wert wird upgedatet -> Zug
                % zur�ckgeben.
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
           bNew = BM_simulateMove(b, turn, possMoves(k));
           [vNew, ~] = BM_alphaBetaPruning(bNew, depth-1, alpha, beta, color, turn*-1, w, false);
           v = min(v, vNew);
           if beta > v
              beta = v;
              if toplayer == true
                % Wenn toplayer und Beta wert wird upgedatet -> Zug
                % zur�ckgeben.
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

