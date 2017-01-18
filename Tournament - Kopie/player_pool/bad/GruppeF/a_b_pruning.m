function [ value ] = a_b_pruning(b,color,depth,depthMax,alpha,beta)
global time
global CounterBewertung
global FoundAtLeastOneMove
global NoMobility

if (depth == depthMax)
    CounterBewertung = CounterBewertung + 1;
    tic
    value = EvalMobility(b); % Bewerte-FKT ändern in entsprechende m file
    time = time + toc;
    if time > 5
        NoMobility = 1;
    end
else
    cntChild = 0;
    NumChildNodes = 0;
    
    for i=1:64
        % Nächsten ChildNode bestimmen
        [bChild, cntChild, xFound, yFound] = FindNewChild(b, color, cntChild+1);
        NumChildNodes = NumChildNodes + 1;

        % Falls es keine ChildNodes MEHR gibt, for-Schleife beenden
        if (bChild == 0)
            % Falls es GAR keine Childnodes gibt, ist es sehr gut/schlecht
            if (NumChildNodes == 1)
                value = 64*color*(-1);
            end
            break
        end
        
        % Bewertung des ChildNodes holen
        value = a_b_pruning(bChild,color*(-1),depth+1,depthMax,alpha,beta);

        % Praktisch den MinMax-Algorithmus ausfuehren
        if (color == +1)
            alphaOld = alpha;
            alpha = max(value,alpha);
            value = alpha;
        elseif (color == -1)
            betaOld = beta;
            beta = min(value,beta);
            value = beta;
        end
        
        % Abbrechen falls ein Konter gefunden wurde!
        if (beta <= alpha)
            global CounterBetaBiggerAlpha
            CounterBetaBiggerAlpha = CounterBetaBiggerAlpha + 1;
            break
        end
        
        % Wenn er bis hierhin kommt, wurde ja noch nicht abgebrochen. D.h.
        % es wurde ein besserer Zug gefunden. Falls in Suchebene 0, dann
        % soll er diesen optimalen Zug auch speichern.
        if (depth == 0)
            if ((color == +1 && alphaOld < alpha) || (color == -1 && betaOld > beta))
                FoundAtLeastOneMove = 1;
                FinalMove = bChild;
                save('Aux_savefile', 'FinalMove');
            end
        end
    end
end
