function [ stability ] = BM_hStability( b,color )
% Berechnet die Stability Heueristic
    nCorners = b(1,1).^2+b(8,1).^2+b(1,8).^2+b(8,8).^2;
    if nCorners == 0
        stability = 0;
    else
        nStableColor = BM_getnStable(b,color);
        nStableOpponent = BM_getnStable(b,-color);
        stability = 100*(nStableColor-nStableOpponent)/(nStableColor+nStableOpponent);
    end
end

