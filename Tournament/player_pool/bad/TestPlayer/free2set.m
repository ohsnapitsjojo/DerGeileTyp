function [allowed_fields_matrix, allowed_fields_koord] = free2set(field, colour)
%field: Spielfeld, das auf freie Plätze für den nächsten Zug geprüft
%werden soll
%
%colour: Farbe des Spielers
%
%allowed_fields_matrix: Rückgabewert. 8x8 Matrix mit einer 1 als Eintrag auf jedem
%Feld, auf das der Spieler der Farbe colour setzen darf.

    stone_colour_mod = zeros(10,10);
    allowed_fields_koord = [];

    if colour == 1
        stone_colour = (field == -1);
    elseif colour == -1
        stone_colour = (field == 1);
    end
    
    stones = (field ~= 0);
    
    for m = 2:9
        for n = 2:9
           if stone_colour(m-1, n-1) == 1
              stone_colour_mod(m-1:m+1, n-1:n+1) = [1 1 1; 1 1 1; 1 1 1]; 
           end
        end
    end
        
    %allowed_fields_matrix enthält an allen Stellen eine 1, die an einem andersfarbigem
    %Stein liegen und auf denen noch kein Stein liegt
    
    allowed_fields_matrix = stone_colour_mod(2:9, 2:9) - (stone_colour_mod(2:9, 2:9) & stones);
    
    counter = 0;
    for m = 1:8
        for n = 1:8
            if allowed_fields_matrix(m,n) == 1
                for i = -1:1
                    for j = -1:1
                        if free2set_2(field,m,n,i,j,colour,1) == 1
                            allowed_fields_matrix(m,n) = 2;
                        end
                    end
                end
                
                if allowed_fields_matrix(m,n) == 1
                    allowed_fields_matrix(m,n) = 0;
                elseif allowed_fields_matrix(m,n) == 2
                    allowed_fields_matrix(m,n) = 1;
                    counter = counter + 1;
                    allowed_fields_koord(counter, :) = [m, n];
                end
            end
        end
    end
    
        
end

