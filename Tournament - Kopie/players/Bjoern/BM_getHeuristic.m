function [ h ] = BM_getHeuristic( b, w, color )
%  Calculate final Heurisitic

    % Endgame Solver
       winner = BM_getWinner(b);
    if winner == -color
        h = -inf;
    elseif winner == color
        h = inf;
    else
    % Normale Heueristic
        h = w(1)*BM_hCoinParity(b,color)+w(2)*BM_hMobility(b,color)+...
            w(3)*BM_hCornersCaptured(b,color)+w(4)*BM_hStability(b,color)+...
            w(5)*BM_hHeat(b,color); 
    end
end

