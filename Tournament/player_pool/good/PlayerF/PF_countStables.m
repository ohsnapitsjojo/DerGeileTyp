function [n s] = PF_countStables(p,Color)
% Zaehlt stabile Steine auf dem Spielbrett
% In:  p = Spielfeld, Color = betrachtete farbe
% Out: n = Anzahl stabile Steine, s = spielfeldmatrix mit 1ern = stabile
%          Steine des Spielers "Color"
% Ausführungszeit neue Version: 
% durchschnittliche Bretter (board sammlung aus svn,~10000 bretter):
%   !!! Reduzierung von durchschnittlich 2,1ms auf 0,1 ms !!!
% stark besetzte Bretter (eigene sammlung, 2000 bretter)
%   !!! Reduzierung von durchschnittlich 5,5ms auf 1,4 ms !!!
% Zeitangaben für meinen Laptop
% Preis dafür: Spaghetti-Code
%
% Bei ungünstigen Brettern können manchmal einzelne stabile Steine nicht
% erkannt werden aufgrund der Abhängigkeiten. Um dieses Problem zu beheben
% müsste der Algorithmus mehrmals über das Brett laufen. Der zusätzliche
% Rechenaufwand lohnt allerdings nicht, daher wird die erkannte Anzahl der
% ersten Iteration als Schätzwert akzeptiert.

preCheck = [p(1,1) == Color, p(1,8) == Color, p(8,8) == Color, p(8,1) == Color];
if ~any(preCheck)
        n = 0;
        s = zeros(8,8);
        return;
end;
saves = zeros(8,8);

dirs = [ 1 -1 -1  1; ... %hor (links oben Uhrzeigersinn)
         1  1 -1 -1];  %ver
     
     

     
% Außen extra (performance...)
if preCheck(1)
    saves(1,1) = 1;
    for jj = 2:7
        if p(jj,1) == Color
            saves(jj,1) = 1;
        else
            break;
        end;
    end;
    for jj = 2:7     
        if p(1,jj) == Color
            saves(1,jj) = 1;
        else
            break;
        end;
    end;
else jj = 1;
end;
if preCheck(2)
    saves(1,8) = 1;
    for jj = 7:-1:jj+1 %%%%
        %if saves(1,jj) == 1; break; end;
        if p(1,jj) == Color
            saves(1,jj) = 1;
        else
            break;
        end;
    end;
    for jj = 2:7
        if p(jj,8) == Color
            saves(jj,8) = 1;
        else
            break;
        end;
    end;
else jj = 1;
end;
if preCheck(3)
    saves(8,8) = 1;
    for jj = 7:-1:jj+1
        %if saves(jj,8) == 1; break; end;
        if p(jj,8) == Color
            saves(jj,8) = 1;
        else
            break;
        end;
    end;
    for jj = 7:-1:2
        if p(8,jj) == Color
            saves(8,jj) = 1;
        else
            break;
        end;
    end;
else jj = 8;
end;
if preCheck(4)
    saves(8,1) = 1;
    for jj = 2:jj-1
        if p(8,jj) == Color
            saves(8,jj) = 1;
        else
            break;
        end;
    end;
    for jj = 7:-1:2
        if saves(jj,1) == 1; break; end;
        if p(jj,1) == Color
            saves(jj,1) = 1;
        else
            break;
        end;
    end;
end;
    
for jj = 2:4 %4 Umkreisungen außen nach innen, 1. Umreisung darüber...
    corners = [jj,   jj, 9-jj, 9-jj; ...
               jj, 9-jj, 9-jj, jj];
    for kk = 1:4 %4 Ecken
        if preCheck(kk) == false; continue; end;
        corner = corners(:,kk);
        curField = corner;
        dir1 = dirs(1,kk); dir2=dirs(2,kk);
        
        %%%%%%%%%Init : checke "Ecke" und direkte nachbarn:
        
        [result abort] = isDiscStable(p, Color,saves, curField(1),curField(2));
        saves(curField(1),curField(2)) = result;
        if abort == 1; continue; end;
        %hor nachbar
        curField(2) = curField(2) + dir1;
        [result horAbort] = isDiscStable(p, Color,saves, curField(1),curField(2));
        saves(curField(1),curField(2)) = result;
        %ver nachbar
        curField = [corner(1) + dir2, corner(2)];
        [result verAbort] = isDiscStable(p, Color,saves, curField(1),curField(2));
        saves(curField(1),curField(2)) = result;
        %hor nachbar wdh 
        curField = [corner(1), corner(2) + dir1];
        if ~saves(curField(1),curField(2))
            [result horAbort] = isDiscStable(p, Color,saves, curField(1),curField(2));
            saves(curField(1),curField(2)) = result;
        end
        %%%%%%%%%Ende Init
        
        %hor
        if dir1 == 1
            limit = 9 - jj;
        else
            limit = jj;
        end
        
        if ~horAbort
            for ll = curField(2)+dir1:dir1:limit
                curField(2) = ll;
                [result abort] = isDiscStable(p, Color,saves, curField(1),curField(2));
                saves(curField(1),curField(2)) = result;
                if abort;break;end;

            end
        end
        %ver
        if dir2 == 1
            limit = 9 - jj;
        else
            limit = jj;
        end
        curField = [corner(1)+2*dir2;corner(2)];
        if ~verAbort
            for ll = curField(1):dir2:limit
                curField(1) = ll;
                [result abort] = isDiscStable(p, Color,saves, curField(1),curField(2));
                saves(curField(1),curField(2)) = result;
                if abort; break; end;

            end
        end

    end
end


n = sum( saves(:) );
s = saves;

end
        

function [stable abort] = isDiscStable(p, Color, saves, row, col)
field = [row; col];
if p(row,col) ~= Color
    stable = false;
    abort = 1;
    return;
end

if saves(row, col) == 1
    stable = true;
    abort = 2;
    return;
end

mods = [-1 -1  0  1; 
        -1  0 -1 -1];
stable = true;
abort = 0;

for ii = 1:4
    field2 = field + mods(:,ii);
    field3 = field - mods(:,ii);
    
    tmpRes = ( saves(field2(1), field2(2)) == 1);

    if tmpRes; continue; end;

    tmpRes = ( saves(field3(1), field3(2)) == 1);

    if ~tmpRes
        stable = false;
        abort = 1;
        return;
    end
end

end