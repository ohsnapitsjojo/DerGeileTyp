function [ move ] = PF_getDatabaseMove( board, color )
% Diese Funktion liest zunaechst die Datei openings.mat ein, um fuer das
% uebergebene Brett einen sinnvollen Zug zu suchen. Dafuer werden alle
% Bretter in der Variablen openings mit dem Vorhandenen verglichen und ein
% entsprechender Zug zurueckgegeben. Wird kein Zug gefunden, wird ein
% leeres Struct zurueckgegeben.
% Als Datenbank wird die Liste von Robert Gatliff benutzt
% (http://www.othello-club.de/data/openings2/openings.txt). Diese enthaelt
% keine Vorschlaege fuer den dritten Zug.

%% Initialisiere Variablen
global PF_log_moves_total
global PF_log_moves_count
global PF_log_rotate
persistent gamedb

if PF_log_moves_count<=1
    gamedb = load('Spiele.sh.mat');
end

move = struct([]);

%% Bestimme besten naechsten Zug
if PF_log_moves_count >= 0
    % Nach Uebereinstimmung der bisherigen Zuege in der Datenbank suchen
    b1 = repmat( PF_log_moves_total, 1, numel(gamedb.wthorb(1, :)));

    % Suche Spiele auf die die bisherige Folge von Zuegen passt
    if PF_log_moves_count == 1
        games = gamedb.wthorb(1:PF_log_moves_count, :) ~= b1(1:PF_log_moves_count, :);
    else
        games = sum( gamedb.wthorb(1:PF_log_moves_count, :) ~= b1(1:PF_log_moves_count, :) );
    end
    
    % Nicht passende aus Datenbank loeschen
    gamedb.wthorb = gamedb.wthorb(:, games == 0 );
    gamedb.points = gamedb.points(:, games == 0 );
    
    % Den am meisten Erfolg versprechenden Zug suchen
    db_ignore_txt = [char(10) 'Datenbankzug wird nicht gespielt: schlechte Omen.'];
    if color==1
        [dummy, idx] = max( gamedb.points );
        if gamedb.points(idx)<0
            idx = [];
            disp(db_ignore_txt);
            gamedb.wthorb = zeros(60,0,'uint8');
            gamedb.points = zeros(1,0,'int8');
        end
    else
        [dummy, idx] = min( gamedb.points );
        if gamedb.points(idx)>0
            idx = [];
            disp(db_ignore_txt);
            gamedb.wthorb = zeros(60,0,'uint8');
            gamedb.points = zeros(1,0,'int8');
        end
    end
    disp(['Restspiele in Datenbank: ' num2str(numel(gamedb.points))]);
    
    
    %% Bestimme Randbedingungen fuer naechsten Zug
    if idx
        disp(['Endsteine nach diesem Zug: ' num2str(gamedb.points(idx))]);
        
        % Board nach erstem Zug ausrichten
        switch PF_log_rotate
            case 101            % F5
                % do nothing
            case 86             % E6
                % 
                board = fliplr(rot90(board,3));
            case 52             % C4
                % 
                board = rot90(board,2);
            case 67             % D3
                board = fliplr(rot90(board,1));
        end;
        
        idx = idx( randi([1 numel(idx)]) );
        next = gamedb.wthorb(PF_log_moves_count+1, idx);
        moves = PF_validMoves(board, color);
        
        for s = 1:numel(moves)
            if (moves(s).endy*16 + moves(s).endx)==next
                move = moves(s);
                break;
            end
        end;
        
        % Zug nach Rotation ausrichten
        switch PF_log_rotate
            case 101            % F5
                % do nothing, is default
            case 86             % E6
                %
                tmp = move.endx;
                move.endx = move.endy;
                move.endy = tmp;
                
                tmp = move.startx;
                move.startx = move.starty;
                move.starty = tmp;
                
                for r=1:numel(move.shift)
                    switch move.shift(r)
                        case -9
                            move.shift(r) = -9;
                        case -8
                            move.shift(r) = -1;
                        case -7
                            move.shift(r) = 7;
                        case -1
                            move.shift(r) = -8;
                        case +1 
                            move.shift(r) = 8;
                        case +7
                            move.shift(r) = -7;
                        case +8
                            move.shift(r) = 1;
                        case +9
                            move.shift(r) = 9;
                    end
                end
            case 52             % C4
                % 
                move.endy = 9-move.endy;
                move.endx = 9-move.endx;
                
                move.starty = 9-move.starty;
                move.startx = 9-move.startx;
                
                move.shift = -move.shift;
            case 67             % D3
                %
                tmp = 9-move.endx;
                move.endx = 9-move.endy;
                move.endy = tmp;
                
                tmp = 9-move.startx;
                move.startx = 9-move.starty;
                move.starty = tmp;
                
                for r=1:numel(move.shift)
                    switch move.shift(r)
                        case -9
                            move.shift(r) = 9;
                        case -8
                            move.shift(r) = 1;
                        case -7
                            move.shift(r) = -7;
                        case -1
                            move.shift(r) = 8;
                        case +1 
                            move.shift(r) = -8;
                        case +7
                            move.shift(r) = 7;
                        case +8
                            move.shift(r) = -1;
                        case +9
                            move.shift(r) = -9;
                    end
                end
        end;
        
    end 
end

disp(' ');

end
