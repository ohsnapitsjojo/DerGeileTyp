function [flag] = checkFlip(b, color, move )
% Diese Funktion Überprüft ob beim setzene eines Steins auf move ein
% gegnerischer Stein geflippt wird
    flag = false;
    b(move) = color;    % Spielbrett aktualiesieren
  % Mögliche 8 Richtungen 
    opp=b(move(1)-1:move(1)+1,move(2)-1:move(2)+1)==-color;
    dirr=[];
    if opp(1,1)
        dir=[-1,-1];
        dirr=[dirr;dir];
    end
    if opp(1,2)
        dir=[-1,0];
        dirr=[dirr;dir];
    end
    if opp(1,3)
        dir=[-1,1];
        dirr=[dirr;dir];
    end
    if opp(2,1)
        dir=[0,-1];
        dirr=[dirr;dir];
    end
    if opp(2,3)
        dir=[0,1];
        dirr=[dirr;dir];
    end
    if opp(3,1)
        dir=[1,-1];
        dirr=[dirr;dir];
    end
    if opp(3,2)
        dir=[1,0];
        dirr=[dirr;dir];
    end
    if opp(3,3)
        dir=[1,1];
        dirr=[dirr;dir];
    end
    
        
        
    for idx = 1:size(dirr,1)
        if checkFlipDirection(b,color,move,dirr(idx,:)) % Alle Richtungen werden ausprobiert
            flag = true;
            break;
        end
    end
end

