function [ w,depth] = BM_strategy( b )
    % Gibt die gewichtung der Heueristic zurück und tiefe des suchbaums
    n = BM_getnRounds(b);

    % Early 
    if  n < 10
        depth = 5;
        w = [0 0 0 0 1];
    elseif 10 <= n && n  <20
        depth = 5;
        w = [0 0 0 0 1];
    elseif 20 <= n && n  <30
        depth = 5;
        w = [-1 2 3 1.5 1];
    % Mid
    elseif 30 <= n && n  <40
        depth = 6;
        w = [0 2.5 3 1 1];
    % Killer Move
%     elseif 35 <= n && n  <40
%         depth = 6;
%         w = [0 0 0 0 1];
    % Killer Move    
    elseif 40 <= n && n  <44
        depth = 7;
        w = [1 2.5 3 1 1]; 
    elseif 44 <= n && n  <46
        depth = 8;
        w = [1 2.5 3 1.5 1]; 
    elseif 46 <= n && n  <48
        depth = 9;
        w = [1 2.5 3 1.5 1];
    % Killer Move
    elseif 48 <= n
        depth = 60-n;
        w = [1 0 0 0 0];
    end
    if mod(ceil(n/2),2)==1
        w=[0 0 0 0 1];
    end
    if 48 <= n
        depth = 60-n;
        w = [1 0 0 0 0];
    end
        
    % Normalisieren
    w = w/sum(w(:));
end
