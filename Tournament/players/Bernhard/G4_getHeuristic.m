function [ h ] = G4_getHeuristic( b, w, color )
%  Calculate final Heurisitic
    % Endgame Solver
       winner = G4_getWinner(b);
    if winner == -color
        h = -inf;
    elseif winner == color
        h = 500;
    else
    % Normale Heueristic
        h = w(1)*G4_hCoinParity(b,color)+w(2)*G4_hMobility(b,color)+...
            w(3)*G4_hCornersCaptured(b,color)+w(4)*G4_hStability(b,color); 
    end
end

