function b = Spieler_Gruppe_G(b,color,t)

addpath([pwd '/players/Spieler_Gruppe_G']);

%check how many fields are still empty
empty_fields = length(find(b==0));

%change search depth depending on time left and empty fields
if empty_fields < 13
    
    depth = empty_fields;
    
else
    
    if t > 100
        depth = 7;
    elseif t > 40
        depth = 6;
    elseif t > 10
        depth = 5;
    elseif t <= 10
        depth = 4;
    end
    
end



weight = 30;   % Kantengewicht

%calculate best move

Max=800; %Festlegen der Größe der Datenbank auf 200 Möglichkeiten
Abbruch=[];
counter=1;
EM=ones(8,8);
Game=b;
%Ausrechnen der Anzahl der belegten Felder

Anzahl=-3; %Beginnt mit minus 3 da erste Koordinate in Datei Data bei (1,1) beginnt
%Es entspricht also ein Feld von 4 Steinen der Anzahl 1.
for z=1:1:64
    if (Game(z)==1) || (Game(z)==-1)
        Anzahl=Anzahl+1;
    end
end

if Anzahl<13
    if color==1
        load DatenbasisPlus;
    else load DatenbasisMinus;
    end
    
    while isempty(Abbruch) %Durchsucht die Datenbank je Anzahl bis desen Ende erreicht ist oder das Feld gefunden wurde
        
        if counter<Max
            Auswahl=isempty(Data{counter,Anzahl});
            
        else Auswahl=1;
        end
        
        switch Auswahl
            
            case 1 %Falls keine Daten in Datenbank vorhanden wird der beste Zug berechnet
                [cx,cy,value,pass]=CobraCore(b,weight,depth,color,-inf,+inf);
                Abbruch=1;
                
                
                %%%%% calculate the best move %%%%%%%%%%%%%%%%%%%
                
            case 0
                if (Data{counter,Anzahl}==Game)==EM %Falls Feld gefunden wird der beste Zug ausgegeben und die while-Schleife beendet
                    cx=Vektor{counter,Anzahl}(1,1);
                    cy=Vektor{counter,Anzahl}(1,2);
                    pass=0; Abbruch=1;
                    
                    
                    
                else counter=counter+1;
                    
                end
                
        end
        
        
    end    %while Schleife zeile 62
    
else
    
    %calculate best move
    [cx,cy,value,pass]=CobraCore(b,weight,depth,color,-inf,+inf);
    
end

%Flip the pieces & update if we don't pass
if pass==0
    b=flip(b,color,cx,cy);
end



function [compx,compy,value,pass]=CobraCore(Game,weight,depth,color,alpha,beta)

compx = [];
compy = [];
pass = 0;

%if we have reached the bottom (depth = 0)
if depth == 0
    %evaluate the board
    value = evaluate(Game,weight,color);
    return
end

%%%%% calculate the best move %%%%%%%%%%%%%%%%%%%

%find possible moves
pos_moves = possibilities(Game,color);

[x y v] = find(pos_moves);

if isempty(v)     %if we can't move set it up so we pass.
    pass=1;
    value=0;
    compx=0;
    compy=0;
    return
end

value = - inf;

%evaluate those moves
for k = 1:length(v)
    
    %play the move
    newGame = flip(Game,color,x(k),y(k));
    
    %pass the new board to the next depth level
    [nextx,nexty,nextvalue,nextpass] = CobraCore(newGame,weight,depth-1,-color,-beta,-alpha);
    nextvalue = -nextvalue;
    
    %if next move = pass we have to give pass a value
    if nextpass == 1
        nextvalue = 0;
    end
    
    %alpha beta
    if nextvalue >= beta
        value = beta;
        compx = x(k);
        compy = y(k);
        return
    end
    
    if nextvalue > alpha
        alpha = nextvalue;
        compx = x(k);
        compy = y(k);
    end
    
end

value = alpha;

return


function [A] = possibilities(b,color)
%%this function calculates the possible moves based on the current board
%layout (b) and the player's color (color) and returns them in an 8x8
%logical matrix

% tic

%matrix b
%1 corrensponds to white / -1 to black / 0 to empty

A = false(8,8);

%find valid moves

for ii = 1:8
    for jj = 1:8
        
        %check if field is empty
        if b(ii,jj) ~= 0
            continue;
        end
        
        %check for valid moves
        
        %10 (positive x direction, 0 in y direction)
        
        %check if there is an enemy's stone on a neighbouring field
        if ii ~= 8 && b(ii+1,jj) == -color
            
            %check if any enemy stones can be turned round
            iii = ii+2;
            
            while iii < 9
                
                if b(iii,jj) == color
                    A(ii,jj) = true; break;
                else if b(iii,jj) == 0
                        break;
                    end
                end
                
                iii = iii + 1;
                
            end
            
            if A(ii,jj) == true; continue; end;
            
        end
        
        %-10
        %check if there is an enemy's stone on a neighbouring field
        if ii ~= 1 && b(ii-1,jj) == -color
            %check if any enemy stones can be turned round
            iii = ii-2;
            
            
            while iii > 0
                
                if b(iii,jj) == color
                    A(ii,jj) = true; break;
                else if b(iii,jj) == 0
                        break;
                    end
                end
                
                iii = iii - 1;
                
            end
            if A(ii,jj) == true; continue; end;
        end
        
        %01
        %check if there is an enemy's stone on a neighbouring field
        if jj ~= 8 && b(ii,jj+1) == -color
            %check if any enemy stones can be turned round
            jjj = jj+2;
            
            
            while jjj < 9
                
                
                if b(ii,jjj) == color
                    A(ii,jj) = true; break;
                else if b(ii,jjj) == 0
                        break;
                    end
                end
                
                jjj = jjj + 1;
                
            end
            if A(ii,jj) == true; continue; end;
        end
        
        %0-1
        %check if there is an enemy's stone on a neighbouring field
        if jj ~= 1 && b(ii,jj-1) == -color
            %check if any enemy stones can be turned round
            jjj = jj-2;
            
            while jjj > 0
                
                if b(ii,jjj) == color
                    A(ii,jj) = true; break;
                else if b(ii,jjj) == 0
                        break;
                    end
                end
                
                jjj = jjj - 1;
                
            end
            if A(ii,jj) == true; continue; end;
        end
        
        %11
        %check if there is an enemy's stone on a neighbouring field
        if ii ~= 8 && jj ~= 8 && b(ii+1,jj+1) == -color
            %check if any enemy stones can be turned round
            iii = ii+2;
            jjj = jj+2;
            
            
            while iii < 9 && jjj < 9
                
                if b(iii,jjj) == color
                    A(ii,jj) = true; break;
                else if b(iii,jjj) == 0
                        break;
                    end
                end
                
                iii = iii + 1;
                jjj = jjj + 1;
                
            end
            if A(ii,jj) == true; continue; end;
        end
        
        %-1-1
        %check if there is an enemy's stone on a neighbouring field
        if ii ~= 1 && jj ~= 1 && b(ii-1,jj-1) == -color
            %check if any enemy stones can be turned round
            iii = ii-2;
            jjj = jj-2;
            
            while iii > 0 && jjj > 0
                
                if b(iii,jjj) == color
                    A(ii,jj) = true; break;
                else if b(iii,jjj) == 0
                        break;
                    end
                end
                
                iii = iii - 1;
                jjj = jjj - 1;
                
            end
            if A(ii,jj) == true; continue; end;
        end
        
        %1-1
        %check if there is an enemy's stone on a neighbouring field
        if ii ~= 8 && jj ~= 1 && b(ii+1,jj-1) == -color
            %check if any enemy stones can be turned round
            iii = ii+2;
            jjj = jj-2;
            
            while iii < 9 && jjj > 0
                
                if b(iii,jjj) == color
                    A(ii,jj) = true; break;
                else if b(iii,jjj) == 0
                        break;
                    end
                end
                
                iii = iii + 1;
                jjj = jjj - 1;
                
            end
            if A(ii,jj) == true; continue; end;
        end
        
        %-11
        %check if there is an enemy's stone on a neighbouring field
        if ii ~= 1 && jj ~= 8 && b(ii-1,jj+1) == -color
            %check if any enemy stones can be turned round
            iii = ii-2;
            jjj = jj+2;
            
            while iii > 0 && jjj < 9
                
                if b(iii,jjj) == color
                    A(ii,jj) = true; break;
                else if b(iii,jjj) == 0
                        break;
                    end
                end
                
                iii = iii - 1;
                jjj = jjj + 1;
                
            end
            if A(ii,jj) == true; continue; end;
        end
        
    end
end

function [A,value] = flip(b,color,x,y)

%%this function flips the stones and returns the new board with flipped stones
%the function gets the actual board (b), the coordinates x and y of the next move and  the color
%it returns the flipped board A
value = 0;
% tic
%1 corrensponds to white / -1 to black / 0 to empty
A = b;
%find neighbour-stones with -color and flip

%right from stone
if y <= 8
    for ii = y:8
        
        
        %check if there is an enemy's stone on a neighbouring field
        if ii ~= 8 && b(x,ii+1) == -color
            
            %check if any enemy stones can be turned round
            iii = ii+2;
            
            while iii < 9
                if b(x,iii) == color
                    value = value + abs(iii-ii)-1;
                    for z = 0:abs(iii-ii)-1
                        A(x,ii+z) = color;  % flip stone(s)
                    end
                    break;
                else if b(x,iii) == 0
                        break;
                    end
                end
                
                iii = iii + 1;
                
            end
            
            if A(x,ii) == color; break; end;
            
        end
        break;
    end
    
end


%left from stone
if y >= 1
    for ii = y:-1:1
        
        
        %check if there is an enemy's stone on a neighbouring field
        if ii ~= 1 && b(x,ii-1) == -color
            
            %check if any enemy stones can be turned round
            iii = ii-2;
            
            while iii > 0
                if b(x,iii) == color
                    value = value + abs(iii-ii)-1;
                    for z = 0:abs(iii-ii)-1
                        A(x,ii-z) = color;  % flip stone(s)
                    end
                    break;
                    
                else if b(x,iii) == 0
                        break;
                    end
                end
                
                iii = iii -1;
                
            end
            
            if A(x,ii) == color; break; end;
            
        end
        break;
    end
end


%down from stone
if x <= 8
    for jj = x:8
        
        
        %check if there is an enemy's stone on a neighbouring field
        if jj ~= 8 && b(jj+1,y) == -color
            
            %disp('check3')
            %check if any enemy stones can be turned round
            jjj = jj+2;
            
            while jjj < 9
                if b(jjj,y) == color
                    value = value + abs(jjj-jj)-1;
                    for z = 0:abs(jjj-jj)-1
                        A(jj+z,y) = color;  % flip stone(s)
                    end
                    break;
                    
                else if b(jjj,y) == 0
                        break;
                    end
                end
                
                jjj = jjj + 1;
                
            end
            
            if A(jj,y) == color; break; end;
            
        end
        break;
    end
end

%up from stone
if x >= 1
    for jj = x:-1:1
        %     disp('check4')
        
        %check if there is an enemy's stone on a neighbouring field
        if jj ~= 1 && b(jj-1,y) == -color
            
            %check if any enemy stones can be turned round
            jjj = jj-2;
            
            while jjj > 0
                if b(jjj,y) == color
                    value = value + abs(jjj-jj)-1;
                    for z = 0:abs(jjj-jj)-1
                        A(jj-z,y) = color;  % flip stone(s)
                    end
                    break;
                    
                else if b(jjj,y) == 0
                        break;
                    end
                end
                
                jjj = jjj - 1;
                
            end
            
            if A(jj,y) == color; break; end;
            
        end
        break;
    end
end


%down right from stone
if y <= 8 && x <= 8
    jj = y;
    for ii = x:8
        
        
        %check if there is an enemy's stone on a neighbouring field
        if ii ~= 8 && jj ~= 8 && b(ii+1,jj+1) == -color
            
            %check if any enemy stones can be turned round
            iii = ii+2;
            jjj = jj+2;
            
            while iii < 9 && jjj < 9
                
                if b(iii,jjj) == color
                    value = value + abs(iii-ii)-1;
                    for z = 0:abs(iii-ii)-1
                        A(ii+z,jj+z) = color;  % flip stone(s)
                    end
                    break;
                    
                else if b(iii,jjj) == 0
                        break;
                    end
                end
                
                iii = iii + 1;
                jjj = jjj + 1;
                
            end
            
            if A(ii,jj) == color; break; end;
            
        end
        break;
        % 	if jj < 8
        % 		jj = jj + 1;
        % 	end
    end
end

%up left from stone
if x >= 1 && y >= 1
    jj = y;
    for ii = x:-1:1
        %%disp('check6')
        
        %check if there is an enemy's stone on a neighbouring field
        if ii ~= 1 && jj ~= 1 && b(ii-1,jj-1) == -color
            
            %check if any enemy stones can be turned round
            iii = ii-2;
            jjj = jj-2;
            
            while iii > 0 && jjj > 0
                
                if b(iii,jjj) == color
                    value = value + abs(iii-ii)-1;
                    for z = 0:abs(iii-ii)-1
                        A(ii-z,jj-z) = color;  % flip stone(s)
                    end
                    break;
                    
                else if b(iii,jjj) == 0
                        break;
                    end
                end
                
                iii = iii - 1;
                jjj = jjj - 1;
                
            end
            
            if A(ii,jj) == color; break; end;
            
        end
        break;
        % 	if jj > 1
        % 		jj = jj - 1;
        % 	end
    end
end

%up right from stone
if y >= 1 && x <= 8
    jj = y;
    for ii = x:8
        
        
        %check if there is an enemy's stone on a neighbouring field
        if ii ~= 8 && jj ~= 1 && b(ii+1,jj-1) == -color
            
            %check if any enemy stones can be turned round
            iii = ii+2;
            jjj = jj-2;
            
            while iii < 9 && jjj > 0
                
                if b(iii,jjj) == color
                    value = value + abs(iii-ii)-1;
                    for z = 0:abs(ii-iii)-1
                        A(ii+z,jj-z) = color;  % flip stone(s)
                    end
                    break;
                    
                else if b(iii,jjj) == 0
                        break;
                    end
                end
                
                iii = iii + 1;
                jjj = jjj - 1;
                
            end
            
            if A(ii,jj) == color; break; end;
            
        end
        break;
        %
        % 	if jj > 1
        % 		jj = jj - 1;
        % 	end
    end
end

%down left from stone
if y <= 8 && x >= 1
    jj = y;
    for ii = x:-1:1
        %%disp('check8')
        
        %check if there is an enemy's stone on a neighbouring field
        if ii ~= 1 && jj ~= 8 && b(ii-1,jj+1) == -color
            
            %check if any enemy stones can be turned round
            iii = ii-2;
            jjj = jj+2;
            
            while iii > 0 && jjj < 9
                
                if b(iii,jjj) == color
                    value = value + abs(iii-ii)-1;
                    for z = 0:abs(iii-ii)-1
                        A(ii-z,jj+z) = color;  % flip stone(s)
                    end
                    break;
                    
                else if b(iii,jjj) == 0
                        break;
                    end
                end
                
                iii = iii - 1;
                jjj = jjj + 1;
                
            end
            
            if A(ii,jj) == color; break; end;
            
        end
        break;
        % 	if jj < 8
        % 		jj = jj + 1;
        % 	end
    end
end


function [value] = evaluate(b ,weight, color)

% function evaluates board (C)
% gets the actual board b and the weight. It returns an evaluationvalue

value = 0;
for ii =1:8
    for jj = 1:8
        
        %evaluate for white player (1)
        
        %x-field
        if (ii==2||ii==7) && (jj==2||jj==7)
            
            if ( b( round_18(ii),round_18(jj) ) == b(ii,jj) )
                value = value + b(ii,jj) * 110;
            else
                value = value - b(ii,jj) * 80;
            end
            
            %inner square 6x6
        elseif (ii>1 || ii<8) && (jj>1 || jj<8)
            value = value + b(ii,jj) * 1;
            
            %cornerstone
        elseif (ii==1||ii==8) && (jj==1||jj==8)
            value = value + b(ii,jj)*100;
            
            %edgestone without cornerstone and stone next to corner
        elseif ( ((ii==1||ii==8) && jj>2 && jj<7) || ((jj==1||jj==8) && ii>2 && ii<7) )
            value = value + b(ii,jj)*40;
            
            %c-fields (the rest!!!)
        else
            
            if ( b( round_18(ii),round_18(jj) ) == b(ii,jj) )
                value = value + b(ii,jj) * 110;
            else
                value = value - b(ii,jj) * 80;
            end
            
        end
        
    end
end

%revert value if color == black (-1)
value = color * value;

function [erg] = round_18 (number)

if ( abs(number-1) < abs(number-8) )
    erg = 1;
else
    erg = 8;
end

