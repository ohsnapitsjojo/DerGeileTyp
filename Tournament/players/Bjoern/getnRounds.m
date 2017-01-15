function [ n ] = getnRounds( b )
% Gibt die Anzahl der bereits gespielten Runden aus
    b = b.^2;
    n = sum(b(:)) - 4;
end

