function [ coinParity ] = hCoinParity( b,color )
% Diese Funktion gibt den Coin Parity Wert zurück in Intervall
%(worst cast/best case) [-100 100]
    own = sum(sum(b==color));
    opp = sum(sum(b==-color));
    coinParity = 100*(own-opp)/(own+opp);
end

