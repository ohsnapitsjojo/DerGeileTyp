function [ w,depth] = strategy( b )
    % Gibt die gewichtung der Heueristic zurück und tiefe des suchbaums
    n = getnRounds(b);
    nStart = 0;
    nMid = 15;
    nLate = 45;
    nKiller = 55;
    % Early 
    if nStart <= n  && n < nMid
        depth = 3;
        w = [0 20 0 10];
    % Mid
    elseif nMid <= n && n < nLate
        depth = 5;
        w = [0 10 0 20];
    % Late
    elseif nLate <= n && n  <nKiller
        depth = 7;
        w = [5 0 0 10];
    % Killer Move
    elseif nKiller <= n
        depth = 60-n;
        w = [10 0 0 0];
    end
    % Normalisieren
    w = w/sum(w(:));
end

