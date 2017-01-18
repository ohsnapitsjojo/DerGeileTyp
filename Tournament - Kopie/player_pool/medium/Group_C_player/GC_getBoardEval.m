function [eval] = GC_getBoardEval(board, move, flippedDisks, movesNumber, color, roundNo)

    %Einstellungen
    
    moveW = 5; %Gewichtung der Zugmöglichkeiten
    scoreW = 1; %Gewichtung des Spielstandes
    cornerW = 4; %Gewichtung der Ecken
    cFieldW = -2;
    xFieldW = -3;
        
    %Spielstand
    score = sum(board(:))*color; %Aktuelle Steinedifferenz
        
    %Ecken
    corner = (board(1,1)+board(1,8)+board(8,1)+board(8,8))*color;
    
    %C-Felder
    cField = (board(2,1) + board(1,2) + board(2,8) + board(1,7) ...
        + board(8,2) + board(7,1) + board(8,7) + board(7,8))*color;
    
    %X-Felder
    xField = board(2,2)+board(2,7)+board(7,2)+board(7,7)*color;
    
    eval = moveW*movesNumber + scoreW*score + cornerW*corner + cFieldW*cField + xFieldW*xField;