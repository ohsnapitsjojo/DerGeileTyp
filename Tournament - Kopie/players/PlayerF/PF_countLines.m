function lines = PF_countLines(b, Color)
% Zaehlt Linien.
% In:
% b = Spielfeld
% Color = Spielerfarbe
% Out: (4 Zeilen)
% lines(1) = Komplette gerade Linien (Laenge 8)
% lines(2) = Komplette diagonale Linien (Laenge 4-8) normalisiert auf
%            8 (4er Diagonale zählt als 0.5...)
% lines(3) = Fast komplette gerade Linien (Laenge 7) 
% lines(4) = Fast komplette diagonale Linien (Laenge 4-7) normalisiert auf 8
%            (4 Steine in einer 5er Diagonale zählen als 0.5 ...)
%
% Ausführungszeit auf ungefähr 1/7 von countLines() reduziert.

%% Gegnerische Steine entfernen
b( b == -Color ) = 0;
lines= zeros(4,1);
% Abbruch falls nur 0er am Rand
if ~any( [b(1,:), b(:,1)', b(8,:), b(:,8)'] )
    return;
end
% Eigene Steine = 1 (für summierungen)
b( b == Color ) = 1;


%% Gerade Linien
t1 = [sum(b,1), sum(b,2)'];
lines(1) = sum( t1 == 8 );
lines(2) = sum( t1 == 7 );

%% Diagonale Linien (laenge >= 4)
b_rot = rot90(b);

for ii=-4:4
    t1 = sum( diag(b, ii) );
    t2 = sum( diag(b_rot, ii) );
	t3 = 7 - abs(ii);

    if t1 < t3 
		%intentionally left blank
	elseif t1 == t3
		lines(4) = lines(4) + t1 / 8;
    else
		lines(3) = lines(3) + t1 / 8;
    end
 
	if t2 < t3 
		%intentionally left blank
	elseif t2 == t3
		lines(4) = lines(4) + t2 / 8;
    else
		lines(3) = lines(3) + t2 / 8;
	end

end

end