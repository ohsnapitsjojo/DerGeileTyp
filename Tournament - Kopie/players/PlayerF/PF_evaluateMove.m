function [value] = PF_evaluateMove(b,color)
%% EVALUATEMOVE
%Diese funktion erh�lt ein bereits ver�ndertes Spielfeld und bewertet
%dieses.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%InputVariablen:
%   - Spielfeld 'b' als 8x8 Matrix mit Elementen aus {-1,0,1}
%   - Prespektive aus der zu bewerten ist durch 'color' aus {-1,1}

%Outputvariable:
%   - Skalare Bewertungsgr��e des Spielfedes 'value'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Die Funktion:

%value=Cm*Mobilit�t+Cs(AnzahlZ�ge)*Anzahl_Steine+Cf*Wert+
%       Cstab*Stabile_Steine*Clines*Lines_vec   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Funktiobsbausteine:

%Differenz der Mobilit�t gewichtitet mit Cm:
%   -   Approximiert m�gliche Z�ge des Gegners/einem Selbst durch
%       Anzahl der leeren Felder nemen einem eigenen/gegnerischen Stein
%   -   Approximation ist ca. Faktor 10 schneller als validMoves, siehe test 
%   -   Cm=constant=100

%Anzahl Steine mit denen man f�hrt/hinten liegt
%   -   Anzahl_Steine=Eigene-Gegner
%   -   Cs(Anzahl_Z�ge) ist linear Kombination zwischen -25 und 25

%Wert der Felder
%   -   Wert_Felder=Eigener_Feld_Wert-Gegner_Feld_Wert
%   -   Cf=constant=1

%Differenz an stabilen Steinen
%   -   Diff_Stab=Eigene-Gegner
%   -   Cstab=constant=7.5k; %%75% von Eckstein
%
%Anzahl der eigenen Linien auf dem Board
%   -   lines ist Vektor=[kompl Reihen,kompl Diag, fast. kompl.
%       Reihen, fast. kompl. Diag]
%   -   Clines=[30 30 15 10]*50
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%TODO:ECKEN_PATTERNS/LETZTER ZUG (SCHWIERIG WEGEN PASSEN)/VALIDMOVES?

%% Approximierte Mobilit�t
diff_delta_mobility=PF_countMobility(b,color)-PF_countMobility(b,-color);
Cm=1000;

%% Anzahl der Steine
move_count=sum(sum(abs(b)));
num_stones=color*sum(b(:));
Cs=1000*(move_count/60-0.5);

%killer move mit inf gewichten
if(isempty(b(b==-color)))
    num_stones=inf;
    Cs=1;
end   

%% Wert Felder
cost_fields=[  10000       -7500        1000         800         800        1000    -7500       10000;
               -7500       -8500        -450        -500        -500        -450    -8500       -7500;
                1000        -450          30          10          10          30     -450        1000;
                 800        -500          10          50          50          10     -500         800;
                 800        -500          10          50          50          10     -500         800;
                1000        -450          30          10          10          30     -450        1000;
               -7500       -8500        -450        -500        -500        -450    -8500       -7500;
               10000       -7500        1000         800         800        1000    -7500       10000;  ];
cost_sign1=ones(8,8);
cost_sign2=ones(8,8);

%Modifiziere Kosten
%Feld o.l.
if(b(1,1)==color)
    cost_sign1(2,1)=-1;
    cost_sign1(1,2)=-1;
    cost_sign1(2,2)=-1;
else
    if(b(1,1)==-color)
        cost_sign2(2,1)=-1;
        cost_sign2(1,2)=-1;
        cost_sign2(2,2)=-1;
    end
end

%Feld o.r.
if(b(1,8)==color)
    cost_sign1(2,8)=-1;
    cost_sign1(1,7)=-1;
    cost_sign1(2,7)=-1;
else
    if(b(1,8)==-color)
        cost_sign2(2,8)=-1;
        cost_sign2(1,7)=-1;
        cost_sign2(2,7)=-1;
    end
end

%Feld u.l.
if(b(8,1)==color)
    cost_sign1(8,2)=-1;
    cost_sign1(7,1)=-1;
    cost_sign1(7,2)=-1;
else
    if(b(8,1)==-color)
        cost_sign2(8,2)=-1;
        cost_sign2(7,1)=-1;
        cost_sign2(7,2)=-1;
    end
end

%Feld u.r. mit color belegt
if(b(8,8)==color)
    cost_sign1(8,7)=-1;
    cost_sign1(7,8)=-1;
    cost_sign1(7,7)=-1;
else
    if(b(8,8)==-color)
        cost_sign2(8,7)=-1;
        cost_sign2(7,8)=-1;
        cost_sign2(7,7)=-1;
    end
end

cost_fields_mod=cost_sign1.*cost_fields;
cost_fields_mod2=cost_sign2.*cost_fields;
value_fields=sum(cost_fields_mod(b==color))-sum(cost_fields_mod2(b==-color));

Cf=10;

%% Anzahl Stabiler Steine 
diff_delta_stables=PF_countStables(b,color)-PF_countStables(b,-color);
Cstab=0.75*cost_fields(1,1);

%% Anzahl der Linien
lines=PF_countLines(b, color);
Clines=[30 30 15 10]*50;

%% Evaluation Funktion
value=Cm*diff_delta_mobility+Cs*num_stones+Cf*value_fields+Cstab*diff_delta_stables+Clines*lines;

end

