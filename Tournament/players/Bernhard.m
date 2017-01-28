function [ b] = Bernhard( b,color,t)
    addpath(['players' filesep 'Bernhard']);
    
    % Alle M�glichen Z�ge
    
    possible = G4_allPossible(b,color);
    
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
        % F�hrt Force Move auf Corner aus wenn m�glich
        move = G4_forceCorners(b,color,possible);
        
        if isempty(move)
        % Minimax Zug
            [w,depth] = G4_strategy(b);
            %w = [1 10 0 20];
            %depth = 5;
            move = G4_alphaBeta( b, color, depth, w );
        end
        % F�hrt Avoid Move f�r Close Corners aus wenn m�glich
        
        % Schneided minimal Schlechter ab gegen Testspieler aber erh�ht die
        % effektivit�t geggen extrem gute gegner
        move = G4_forceAvoid(b,color,possible,move);

        % Fehlerbehebung wenn m�glicher Zug nicht erkannt wird
        if ~isempty(possible) && isempty(move)
            [~,ind] = max(aMap(possible));
            move = possible(ind);
            warning('Es wurde kein Zug zur�ckgegeben obwohl ein m�glicher Zug existiert, nehme besten Zug anhand statischer Zuggewichtung');
        end
        if ~isempty(move)
            b = G4_simulateMove(b,color,move); 
        end
    catch ME
        % Fehlerbehebung f�r fehler im Code
        warning(ME.message);
        warning('Ein Fehler ist aufgetreten, nehme besten Zug anhand statischer Zuggewichtung');   
        [~,ind] = max(aMap(possible));
        move = possible(ind);
        b = G4_simulateMove(b,color,move);
    end

    rmpath(['players' filesep 'Bernhard']);
end

