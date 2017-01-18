function [ x, y ] = G4_idx2xy( index )
% Konvertiert matrix Index zu Reihe (y) und Spalte (x) der Matrix (8x8)
    x = ceil(index/8);
    y = mod(index,8);
    if(y==0)
        y = 8;
    end
end

