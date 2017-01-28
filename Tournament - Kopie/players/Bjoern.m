function [ b] =Bjoern( b,color,t)
%auf Basis von Bernahrd
    addpath(['players' filesep 'Bjoern']);
    
    % Alle M�glichen Z�ge
    possible = BM_allPossible(b,color);
    
    % Statische Gewichtung f�r Z�ge
    aMap = [1000        -300         100          80          80         100        -300        1000;...
            -300        -500         -45         -50         -50         -45        -500        -300;...
            100         -45           3           1           1           3         -45         100;...
            80         -50           1           5           5           1         -50          80;...
            80         -50           1           5           5           1         -50          80;...
            100         -45           3           1           1           3         -45         100;...
            -300        -500         -45         -50         -50         -45        -500        -300;...
            1000        -300         100          80          80         100        -300        1000];
    % Statische Gewichtung f�r Z�ge

    try


            [w,depth] = BM_strategy(b);
            move = BM_alphaBeta( b, color, depth, w );

        if ~isempty(possible) && isempty(move)
            [~,ind] = max(aMap(possible));
            move = possible(ind);
            warning('Es wurde kein Zug zur�ckgegeben obwohl ein m�glicher Zug existiert, nehme besten Zug anhand statischer Zuggewichtung');
        end
        if ~isempty(move)
            b = BM_simulateMove(b,color,move); 
        end
    catch ME
        % Fehlerbehebung f�r fehler im Code
        warning(ME.message);
        warning('Ein Fehler ist aufgetreten, nehme besten Zug anhand statischer Zuggewichtung');   
        [~,ind] = max(aMap(possible));
        move = possible(ind);
        b = BM_simulateMove(b,color,move);
    end

end

