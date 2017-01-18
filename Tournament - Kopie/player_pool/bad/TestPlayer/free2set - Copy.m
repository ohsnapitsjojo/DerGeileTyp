function [allowed_fields_matrix, allowed_fields_koord] = free2set(field, colour)
%field: Spielfeld, das auf freie Plätze für den nächsten Zug geprüft
%werden soll
%
%colour: Farbe des Spielers
%
%allowed_fields_matrix: Rückgabewert. 8x8 Matrix mit einer 1 als Eintrag auf jedem
%Feld, auf das der Spieler der Farbe colour setzen darf.

    stone_colour_mod = zeros(8,8);

    if colour == 1
        stone_colour = (field == -1);
    elseif colour == -1
        stone_colour = (field == 1);
    end
    
    stones = (field ~= 0);
    
    for m = 1:8
        for n = 1:8
            if stone_colour(m,n) == 1
                if (m == 1) && not((n == 1) || (n == 8))
                    stone_colour_mod(m+1,n) = 1;
                elseif (m == 8) && not((n == 1) || (n == 8))
                    stone_colour_mod(m-1,n) = 1;
                else
                    if not((n == 1) || (n == 8))
                        stone_colour_mod(m+1,n) = 1;
                        stone_colour_mod(m-1,n) = 1;
                    end
                end
                
                if (n == 1) && not((m == 1) || (m == 8))
                    stone_colour_mod(m,n+1) = 1;
                elseif (n == 8) && not((m == 1) || (m == 8))
                    stone_colour_mod(m,n-1) = 1;
                else
                    if  not((m == 1) || (m == 8))
                        stone_colour_mod(m,n+1) = 1;
                        stone_colour_mod(m,n-1) = 1;
                    end
                end
                
                if (m == 1) && (n == 1)
                    stone_colour_mod(m+1,n+1) = 1;
                    stone_colour_mod(m,n+1) = 1;
                    stone_colour_mod(m+1,n) = 1;
                elseif (m == 1) && (n == 8)
                    stone_colour_mod(m+1,n-1) = 1;
                    stone_colour_mod(m,n-1) = 1;
                    stone_colour_mod(m+1,n) = 1;
                elseif (m == 8) && (n == 1)
                    stone_colour_mod(m-1,n+1) = 1;
                    stone_colour_mod(m,n+1) = 1;
                    stone_colour_mod(m-1,n) = 1;
                elseif (m == 8) && (n == 8)
                    stone_colour_mod(m-1,n-1) = 1;
                    stone_colour_mod(m,n-1) = 1;
                    stone_colour_mod(m-1,n) = 1;
                else
                    if not((m == 1) || (m == 8) || (n == 1) || (n == 8))
                        stone_colour_mod(m-1,n-1) = 1;
                        stone_colour_mod(m+1,n-1) = 1;
                        stone_colour_mod(m-1,n+1) = 1;
                        stone_colour_mod(m+1,n+1) = 1;
                    end
                end
            end
        end
    end
    
    %allowed_fields_matrix enthält an allen Stellen eine 1, die an einem andersfarbigem
    %Stein liegen und auf denen noch kein Stein liegt
    
    allowed_fields_matrix = stone_colour_mod - (stone_colour_mod & stones);
    
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
                end
            end
        end
    end
    
    sumfields = sum(allowed_fields_matrix(:));
    allowed_fields_koord = zeros(sumfields, 2);
    counter = 0;
    for n = 1:8
        for m = 1:8
            if allowed_fields_matrix(n,m) == 1
                counter = counter + 1;
                allowed_fields_koord(counter, :) = [n, m];
            end
        end        
    end
    
end

