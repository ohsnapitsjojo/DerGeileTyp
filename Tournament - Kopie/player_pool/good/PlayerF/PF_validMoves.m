function [ moves ] = PF_validMoves( b, color )
%VALIDMOVE Summary of this function goes here
%   Funktion gibt Struct mit folgenden Attributen zur�ck:
%   endy: Reihe des gueltigen Zugs
%   endx: Spalte des gueltigen Zugs
%   starty: Vektor mit Zeilen zu zugeh�rigen Anfangssteinen
%   startx: Vektor mit Spalten zu zugeh�rigen Anfangssteinen
%   length: Vektor mit Anzahl Steinen zwischen Anfang und Ende
%   shift: Lineare Verschiebung, Angabe zur Richtung
%   lines:  Anzahl der Start-Steine

shift = [-1 -1; 0 -1; 1 -1; -1 0; 1 0; -1 1; 0 1; 1 1];
shift_lin =  [-9 -8 -7 -1 1 7 8 9];
filter=ones(3);
filter(2,2)=0;

% Indizes von Null-Steinen
b1=b;
b2=b;
b1(b1~=0)=NaN;
b2(b2~=-color)=0;
b2=conv2(b2,filter,'same')+b1;
[pendy pendx] = find(color*b2<0);

endpoints = length(pendy);
% Struct fuer gueltige Z�ge, Speicher allokieren
moves = struct('endy', cell(endpoints*8,1), 'endx', 0, 'starty', 0, 'startx', 0, 'length', 0, 'lines', 0, 'shift', 0); 

% Bereits benutzte Endsteine zwischenspeichern (schneller suchen)
mey = zeros(endpoints*8, 1);
mex = zeros(endpoints*8, 1);

endpoints = 0;
% Teste jeden eigenen Stein
for r = 1:length(pendy)
    p = [pendy(r) pendx(r)];
    
    % Teste jede Richung
    for s = 1:8
        d = p-shift(s, :);
        laenge = 0;

        % Solange bis kein gegnerischer Stein dahinter liegt
        while d(1)>=1 && d(2)>=1 && d(1)<=8 && d(2)<=8 && b(d(1), d(2))==-color
            laenge = laenge+1;
            d = d-shift(s, :);
        end;
        
        if laenge>0 && d(1)>=1 && d(2)>=1 && d(1)<=8 && d(2)<=8 && b(d(1), d(2))==color
            % Suche, ob dieser Endstein schon benutzt wurde
            m = find(bitand(mey==p(1), mex==p(2)));
            
            
            if isempty(m)
                endpoints = endpoints+1;
                ind = endpoints;
                
                % diese Werte muessen nur einmal geschrieben werden
                moves(ind).endy = p(1);   mey(ind) = p(1);
                moves(ind).endx = p(2);   mex(ind) = p(2);
            else
                % Falls der Endstein schon benutzt wurde, werden zum
                % entsprechenden Struct-Element weitere Werte hinzugef�gt
                ind = m;
            end;
                
            % Diese Werte muessen fuer jede Linie von jedem Endstein
            % geschrieben werden:
            moves(ind).lines = moves(ind).lines + 1;
            moves(ind).starty(moves(ind).lines) = d(1);
            moves(ind).startx(moves(ind).lines) = d(2);
            moves(ind).length(moves(ind).lines) = laenge;
            moves(ind).shift(moves(ind).lines) = shift_lin(s);
        end;
    end;
end;

moves = moves(1:endpoints);

end

