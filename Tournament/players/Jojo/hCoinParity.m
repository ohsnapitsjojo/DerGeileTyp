function [ coinParity ] = hCoinParity( b,color )
% Diese Funktion gibt den Coin Parity Wert zurück in Intervall
%(worst cast/best case) [-100 100]
        
    num = sum(b(:));
    num = num*color;
    b_pos = b.^2;
    den = sum(b_pos(:));

    coinParity = 100*(num/den);
end

