function value = EvalMobility(b)

global NoMobility

%%
% Steine jeder Farbe zählen und Majoritätsfaktor p bilden
nonzero = nnz(b);
summe = sum(sum(b));

if summe < 0
    blacks = ceil((nonzero + summe)/2);
    whites = blacks - summe;
    p = -100*whites/(nonzero);
elseif summe > 0
    whites = ceil((nonzero - summe)/2);
    blacks = whites + summe;
    p = 100*blacks/(nonzero);
    
else 
    p = 0; 
end

%%
% Spielfeld auf Ecksteine untersuchen und nach Farben gewichten 
corner_check = [b(1,1) b(1,8);...
                b(8,1) b(8,8)];           
nonzero = nnz(corner_check);
summe = sum(sum(corner_check));
if summe < 0
    blacks = ceil((nonzero + summe)/2);
    whites = blacks - summe;
elseif summe > 0
    whites = ceil((nonzero - summe)/2);
    blacks = whites + summe;
else 
    blacks = nonzero/2;
    whites = blacks;
end 
c = 25*blacks - 25*whites;


%%
% Steine in der Nähe der Ecken negativ gewichten und Faktor l bilden
close_corner = [b(1,7) b(7,1) b(7,7)...
                b(2,1) b(2,7) b(1,2)...
                b(2,8) b(2,2) b(7,2)...
                b(8,2) b(7,8) b(8,7)];
nonzero = nnz(close_corner);
summe = sum(close_corner);
if summe < 0
    blacks = ceil((nonzero + summe)/2);
    whites = blacks - summe;
elseif summe > 0
    whites = ceil((nonzero - summe)/2);
    blacks = whites + summe;
else 
    blacks = nonzero/2;
    whites = blacks;
end 
l = -12.5*blacks + 12.5*whites;

%%
% Mobilitätsuntersuchung: checken wieviele mögliche Züge weiß bzw. schwarz
% im ausführen kann. Evtl. wichtig um den Gegner zu Zügen zu zwingen
% Problem im Moment: dauert einfach viel zu lange
if NoMobility ~= 1
    cnt_whites = 0;
    cnt_blacks = 0;
    color = -1;
    for y = 1:8
        for x = 1:8
            if (b(x,y) == 0)
                count = NumFlips(b,color,x,y);
                if count > 0
                    cnt_whites = cnt_whites + 1;
                end
            end
        end
    end

    color = 1;
    for y = 1:8
        for x = 1:8
            if (b(x,y) == 0)
                count = NumFlips(b,color,x,y);
                if count > 0
                   cnt_blacks = cnt_blacks + 1;
                end
            end
        end
    end

    if (cnt_blacks > cnt_whites)
        m = 100*cnt_blacks/(cnt_blacks + cnt_whites);

    elseif (cnt_blacks < cnt_whites)
        m = -100*cnt_whites/(cnt_blacks + cnt_whites);
    else
        m = 0; 
    end
else
    m = 0;
end


%%
% Hier könnte evtl noch eine untersuchung der FrontierStones eingefügt werden
% um zu checken wieviele Steine an leere Felder angrenzen, dieser Faktor
% sollte minimal sein
%%
% Bewertungsmatrix bilden und mit Spielfeld multiplizieren

EvaluationMatrix =   [ 20  -3   11    8    8   11   -3   20;...  % 1 x
                      -3   -7   -4    1    1   -4   -7   -3;...  % 2 |
                       11  -4    2    2    2    2   -4   11;...   % 3 v
                       8    1    2   -3   -3    2    1    8;...   % 4
                       8    1    2   -3   -3    2    1    8;...   % 5
                       11  -4    2    2    2    2   -4   11;...   % 6
                      -3   -7   -4    1    1   -4   -7   -3;...  % 7
                       20  -3   11    8    8   11   -3   20];    % 8
  

d = sum(sum( b.*EvaluationMatrix ));
%%
% Alle Charakteristiken gewichten und aufsummieren
charakteristics = [p c l m d];
weights = [65 90 65 55 60];

value = sum(weights.*charakteristics);


end

