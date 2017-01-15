function [ b] = Bernhard( b,color,t)
    addpath(['players' filesep 'Bernhard']);
    
    % Alle Möglichen Züge
    possible = allPossible(b,color);
    
    % Statische Gewichtung für Züge
    aMap = [1000        -300         100          80          80         100        -300        1000;...
            -300        -500         -45         -50         -50         -45        -500        -300;...
            100         -45           3           1           1           3         -45         100;...
            80         -50           1           5           5           1         -50          80;...
            80         -50           1           5           5           1         -50          80;...
            100         -45           3           1           1           3         -45         100;...
            -300        -500         -45         -50         -50         -45        -500        -300;...
            1000        -300         100          80          80         100        -300        1000];
    % Statische Gewichtung für Züge
    
    try
        % Führt Force Move auf Corner aus wenn möglich
        move = forceCorners(b,color,possible);
        
        if isempty(move)
        % Minimax Zug
            [w,depth] = strategy(b);
            %w = [1 10 0 20];
            %depth = 5;
            move = alphaBeta( b, color, depth, w );
        end
        % Führt Avoid Move für Close Corners aus wenn möglich
        move = forceAvoid(b,color,possible,move);

        % Fehlerbehebung wenn möglicher Zug nicht erkannt wird
        if ~isempty(possible) && isempty(move)
            [~,ind] = max(aMap(possible));
            move = possible(ind);
            warning('Es wurde kein Zug zurückgegeben obwohl ein möglicher Zug existiert, nehme besten Zug anhand statischer Zuggewichtung');
        end
        if ~isempty(move)
            b = simulateMove(b,color,move); 
        end
    catch ME
        % Fehlerbehebung für fehler im Code
        warning(ME.message);
        warning('Ein Fehler ist aufgetreten, nehme besten Zug anhand statischer Zuggewichtung');   
        [~,ind] = max(aMap(possible));
        move = possible(ind);
        b = simulateMove(b,color,move);
    end

    rmpath(['players' filesep 'Bernhard']);
end

