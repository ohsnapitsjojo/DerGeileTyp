function [ w,depth] = G4_strategy( b )
    % Gibt die Gewichtung der Heueristik zurück und die Tiefe des Suchbaums
    n = G4_getnRounds(b);
    nStart = 0;
    nMid = 15;
    nLate = 40;
    nKiller = 52;
    % Early 
    if nStart <= n  && n < nMid
        depth = 5;
        w = [0 20 20 10];
    % Mid
    elseif nMid <= n && n < nLate
        depth = 5;
        w = [0 10 20 20];
    % Late
    elseif nLate <= n && n  <nKiller
        depth = 7;
        w = [0 0 20 10];
    % Killer Move
    elseif nKiller <= n
        depth = 60-n;
        w = [10 0 0 0];
    end
    % Normalisieren
    w = w/sum(w(:));
end

