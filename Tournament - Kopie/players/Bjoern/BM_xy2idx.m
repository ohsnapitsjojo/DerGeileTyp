function [ index ] = BM_xy2idx( x,y )
% Überführ Reihe (y) und Spalte(x) in den Matirx index
    index = (x-1)*8+y;
end

