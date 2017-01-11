function [ value_of_lines ] = ValueOfLines(b,color)

value_of_lines = 0;

% Vgl. http://othellomaster.com/OM/Report/HTML/report.html#SECTION00034000000000000000
% Abschnitt "Line Accountability"

% 1. Durch alle Reihen horizontal durchgehen, schauen wie viele Steine
%    in einer Reihe wir haben. Für alle Steine, die Elemente einer Reihe
%    sind nehmen wir die Wertung aus der Matrix der Webseite und summieren
val_mat_horiz = [ 5 5 5 5 5 5 5 5,
                  4 4 4 4 4 4 4 4,
                  3 3 3 3 3 3 3 3,
                  2 2 2 2 2 2 2 2,
                  2 2 2 2 2 2 2 2,
                  3 3 3 3 3 3 3 3,
                  4 4 4 4 4 4 4 4,
                  5 5 5 5 5 5 5 5 ];

% disp('');
% disp('CHECKING HORIZONTAL...');
for y = 1:8
    firstStone = 0;
    for x = 1:8
        if b(y,x) == color
            if firstStone ~= 0
                % Wir haben schon einen gefunden => Reihe!
                if firstStone ~= 9
                    value_of_lines = value_of_lines + val_mat_horiz(y, firstStone);
                    firstStone = 9;
                end
                value_of_lines = value_of_lines + val_mat_horiz(y, x);
            else
                % Speichere Position dieses Steines
                firstStone = x;
            end
        else
            firstStone = 0;
        end
%        disp(strcat('Y:', num2str(y), ' X:', num2str(x), ' firstStone:', num2str(firstStone), ' valOfLin:', num2str(value_of_lines)));
    end
end

% 2. Durch alle Reihen vertikal durchgehen, gleiches Prinzip
val_mat_vert = [ 5 4 3 2 2 3 4 5,
                 5 4 3 2 2 3 4 5,
                 5 4 3 2 2 3 4 5,
                 5 4 3 2 2 3 4 5,
                 5 4 3 2 2 3 4 5,
                 5 4 3 2 2 3 4 5,
                 5 4 3 2 2 3 4 5,
                 5 4 3 2 2 3 4 5 ];

% disp('');
% disp('CHECKING VERTICAL...');
for x = 1:8
    firstStone = 0;
    for y = 1:8
        if b(y,x) == color
            if firstStone ~= 0
                % Wir haben schon einen gefunden => Reihe!
                if firstStone ~= 9
                    value_of_lines = value_of_lines + val_mat_vert(firstStone, x);
                    firstStone = 9;
                end
                value_of_lines = value_of_lines + val_mat_vert(y, x);
            else
                % Speichere Position dieses Steines
                firstStone = y;
            end
        else
            firstStone = 0;
        end
%    disp(strcat('X:', num2str(x), ' Y:', num2str(y), ' firstStone:', num2str(firstStone), ' valOfLin:', num2str(value_of_lines)));
    end
end


% 3. Durch alle Reihen diagonal (links unten -> rechts oben) durchgehen,
%    gleiches Prinzip
val_mat_lu_ro = [ 0 0 0 2 2 3 4 5,
                  0 0 2 2 3 4 5 4,
                  0 2 2 3 4 5 4 3,
                  2 2 3 4 5 4 3 2,
                  2 3 4 5 4 3 2 2,
                  3 4 5 4 3 2 2 0,
                  4 5 4 3 2 2 0 0,
                  5 4 3 2 2 0 0 0 ];

% disp('');
% disp('CHECKING DIAG UPPER HALF...');
% linke obere Hälfte der Matrix
for y = 2:8
    checkY = y;
    firstStone = 0;
    for x = 1:y
        if b(checkY, x) == color
            if firstStone ~= 0
                % Wir haben schon einen gefunden => Diagonale
                if firstStone ~= 9
                    value_of_lines = value_of_lines + val_mat_lu_ro(firstStone, firstStoneX);
                    firstStone = 9;
                end
                value_of_lines = value_of_lines + val_mat_lu_ro(checkY, x);
            else
                % Speichere Position
                firstStone = checkY;
                firstStoneX = x;
            end
        else
            firstStone = 0;
        end
%        disp(strcat('Y:', num2str(checkY), ' X:', num2str(x), ' firstStone:', num2str(firstStone), ' valOfLin:', num2str(value_of_lines)));
        checkY = checkY - 1;
    end
end

% disp('');
% disp('CHECKING DIAG LOWER HALF...');
% rechte untere Hälfte der Matrix
for x = 2:7
    checkX = x;
    firstStone = 0;
    for y = 8:-1:x
        if b(y, checkX) == color
            if firstStone ~= 0
                % Wir haben schon einen gefunden => Diagonale
                if firstStone ~= 9
                    value_of_lines = value_of_lines + val_mat_lu_ro(firstStone, firstStoneX);                    firstStone = 9;
                    firstStone = 9;
                end
                value_of_lines = value_of_lines + val_mat_lu_ro(y, checkX);
            else
                % Speichere Position
                firstStone = y;
                firstStoneX = checkX;
            end
        else
            firstStone = 0;
        end
%        disp(strcat('X:', num2str(checkX), ' Y:', num2str(y), ' firstStoneY:', num2str(firstStone), ' firstStoneX:', num2str(firstStoneX), ' valOfLin:', num2str(value_of_lines)));
        checkX = checkX + 1;
    end
end
                    

% 4. Durch alle Reihen diagonal (rechts unten -> links oben) durchgehen,
%    gleiches Prinzip
val_mat_ru_lo = [ 5 4 3 2 2 0 0 0,
                  4 5 4 3 2 2 0 0,
                  3 4 5 4 3 2 2 0,
                  2 3 4 5 4 3 2 2,
                  2 2 3 4 5 4 3 2,
                  0 2 2 3 4 5 4 3,
                  0 0 2 2 3 4 5 4,
                  0 0 0 2 2 3 4 5 ];

% disp('');
% disp('CHECKING DIAG UPPER HALF...');
% rechte obere Hälfte der Matrix
for y = 2:8
    checkY = y;
    firstStone = 0;
    for x = 8:-1:9-y
        if b(checkY, x) == color
            if firstStone ~= 0
                % Wir haben schon einen gefunden => Diagonale
                if firstStone ~= 9
                    value_of_lines = value_of_lines + val_mat_ru_lo(firstStone, firstStoneX);
                    firstStone = 9;
                end
                value_of_lines = value_of_lines + val_mat_ru_lo(checkY, x);
            else
                % Speichere Position
                firstStone = checkY;
                firstStoneX = x;
            end
        else
            firstStone = 0;
        end
%        disp(strcat('Y:', num2str(checkY), ' X:', num2str(x), ' firstStone:', num2str(firstStone), ' valOfLin:', num2str(value_of_lines)));
        checkY = checkY - 1;
    end
end

% disp('');
% disp('CHECKING DIAG LOWER HALF...');
% linke untere Hälfte der Matrix
for x = 2:7
    checkX = x;
    firstStone = 0;
    for y = 8:-1:9-x
        if b(y, checkX) == color
            if firstStone ~= 0
                % Wir haben schon einen gefunden => Diagonale
                if firstStone ~= 9
                    value_of_lines = value_of_lines + val_mat_ru_lo(firstStone, firstStoneX);
                    firstStone = 9;
                end
                value_of_lines = value_of_lines + val_mat_ru_lo(y, checkX);
            else
                % Speichere Position
                firstStone = y;
                firstStoneX = checkX;
            end
        else
            firstStone = 0;
        end
%        disp(strcat('X:', num2str(checkX), ' Y:', num2str(y), ' firstStoneY:', num2str(firstStone), ' firstStoneX:', num2str(firstStoneX), ' valOfLin:', num2str(value_of_lines)));
        checkX = checkX - 1;
    end
end

end