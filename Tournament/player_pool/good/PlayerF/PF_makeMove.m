function [b] = PF_makeMove(b,color,move)
%MAKEMOVE
%Diese Funktion erhält einen gültigen Zug 'move' struct element generiert 
%von valid moves und ein Spielbrett 'b'
%Der Zug wird ausgeführt indem entsprechende Steine zu 'color' gesetzt
%werden
for l=1:move.lines
    ind=move.shift(l)*(1:move.length(l)+1);
    ind_start=sub2ind([8;8],move.starty(l),move.startx(l));
    b(ind_start+ind)=color;
end
end

