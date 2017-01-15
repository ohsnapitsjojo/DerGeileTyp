function [ w,depth] = strategy( b )
    % Gibt die gewichtung der Heueristic zurück und tiefe des suchbaums
    n = getnRounds(b);
    nStart = 0;
    nMid = 15;
    nLate = 45;
    nKiller = 54;
    % Early 
    if nStart <= n  && n < nMid
        depth = 5;
        w = [5 20 10 10];
    % Mid
    elseif nMid <= n && n < nLate
        depth = 5;
        w = [5 10 10 20];
    % Late
    elseif nLate <= n && n  <nKiller
        depth = 7;
        w = [5 0 5 10];
    % Killer Move
    elseif nKiller <= n
        depth = 60-n;
        w = [10 0 0 0];
    end
    % Normalisieren
    w = w/sum(w(:));
end

