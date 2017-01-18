function [FinalMove] = index(b,color,t)

global CounterBetaBiggerAlpha
CounterBetaBiggerAlpha = 0;
global CounterBewertung
CounterBewertung = 0;
global FoundAtLeastOneMove
FoundAtLeastOneMove = 0;
global NumMovesLeft
NumMovesLeft = 0;
global time
time = 0;
global NoMobility
NoMobility = 0;

if t > 15
    %% (0) depthMax = DetermineSuchtiefe(t,b)
    NumMovesAlready = sum(sum(abs(b)));
    NumMovesLeft = 64 - NumMovesAlready;
    depthMax = 6;

    % Suchtiefe soll max. die Anzahl der verbleibenden Zuege sein
    depthMax = min(depthMax,NumMovesLeft);

    %% (1) start a-b-pruning
    depth = 0;
    alpha = -inf;
    beta = +inf;

    value = a_b_pruning(b,color,depth,depthMax,alpha,beta);


    %% (2) Zug bestimmen:
    % Vielleicht ist ja kein Zug möglich, dann Spielfeld zurückgeben
    FinalMove = b;
    if (FoundAtLeastOneMove == 1)
        load('Aux_savefile', 'FinalMove')
    end

else
    %% (3) Zeitnot:
    % Spiele mit maximaler Erbeutung
    % deklaration
    count = zeros(8);
    % moeglichkeiten mit anzahl der flips in count speichern
    for y = 1:8
        for x = 1:8
            if (b(x,y) == 0)
                count(x,y) = NumFlips(b,color,x,y);
            end
        end
    end

    % maximale flips bestimmen
    [anz setx] = max(count);
    [anz sety] = max(anz);
    setx = setx(sety);

    % gefundenen spielzug ausfuehren
    if(anz > 0)
        FinalMove = DoFlips(b,color,setx,sety);
    else
        FinalMove = b;
    end
end
