function [ value_of_lines ] = ValueOfLines(b,color)

%% Ich benutze die Funktion immer um was auszuprobieren, dann muss ich nicht jedesmal eine
%% neue Funktion anlegen. Die vier auskommentierten Zeilen betreffen Diagonalen der erst StonerTraps.
%% Hier kann man gerne weiterarbeiteiten. Ist noch gut unausgereift...

%% Diagonal
% if (b(1,1)==color&&b(2,2)==-color&&b(3,3)==-color&&b(4,4)==-color&&b(5,5)==-color&&b(6,6)==-color&&b(7,7)==-color) value_of_lines = 1; end
% if (b(8,8)==color&&b(2,2)==-color&&b(3,3)==-color&&b(4,4)==-color&&b(5,5)==-color&&b(6,6)==-color&&b(7,7)==-color) value_of_lines = 1; end
% if (b(1,8)==color&&b(2,7)==-color&&b(3,6)==-color&&b(4,5)==-color&&b(5,4)==-color&&b(6,3)==-color&&b(7,2)==-color) value_of_lines = 1; end
% if (b(8,1)==color&&b(2,7)==-color&&b(3,6)==-color&&b(4,5)==-color&&b(5,4)==-color&&b(6,3)==-color&&b(7,2)==-color) value_of_lines = 1; end   

%% StonerTraps
result = zeros(4,1);


for i = 1:4
  
zero = 0;
we = 0;
enemy = 0;

if (b(7,1)==0&&b(7,2)==0&&b(8,1)==0&&b(8,2)==0&&b(8,4)==0&&b(8,8)==0)
    zero = 1;
end
if (b(6,2)==color&&b(4,5)==color&&b(7,3)==color&&b(8,3)==color)
    we = 1;
end
if(b(6,3)==-color&&b(5,4)==-color&&b(6,4)==-color&&b(7,4)==-color&&b(8,5)==-color&&b(8,6)==-color&&b(8,7)==-color)
    enemy = 1;
end

b = rot90(b);

result(i,1) = zero*we*enemy;

end

value_of_lines = logical(sum(result));

end
