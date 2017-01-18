function [ value_of_edges ] = ValueOfEdges(b,color)
 
%% Search for even and ods eges

value_of_edges = 0;

% even gaps
good_edge_1 = [0;0;color;0;0;color;0;0];
good_edge_2 = [0;color;0;0;0;0;color;0];
good_edge_3 = [color;color;0;0;0;0;color;color];
good_edge_4 = [color;color;color;color;color;color;color;color];
good_edge_5 = [color;color;color;0;0;color;color;color];

% odd gaps // koennen wir auch implementieren ist warsch schneller als ein
% erneuter Funktionsaufruf für den Gegner...
% bad_edge_1  = [0;0;color;0;color;0;0;0];
% bad_edge_2  = [0;0;0;color;0;color;0;0];
% bad_edge_3  = [0;color;0;color;0;0;0;0];
% bad_edge_4  = [0;0;0;0;color;0;color;0];
% bad_edge_5  = [0;0;color;0;0;0;color;0];
% bad_edge_6  = [0;color;0;0;0;color;0;0];

% edges
edge_west = b(1:8,1);
edge_north = b(1,1:8)';
edge_south = b(8,1:8)';
edge_east = b(1:8,8);

%West
if isequal(edge_west,good_edge_1)
 value_of_edges=value_of_edges+1;
end
if isequal(edge_west,good_edge_2)
 value_of_edges=value_of_edges+1;
end
if isequal(edge_west,good_edge_3)
 value_of_edges=value_of_edges+1;
end
if isequal(edge_west,good_edge_4)
 value_of_edges=value_of_edges+1;
end
if isequal(edge_west,good_edge_5)
 value_of_edges=value_of_edges+1;
end

%North
if isequal(edge_north,good_edge_1)
 value_of_edges=value_of_edges+1;
end
if isequal(edge_north,good_edge_2)
 value_of_edges=value_of_edges+1;
end
if isequal(edge_north,good_edge_3)
 value_of_edges=value_of_edges+1;
end
if isequal(edge_north,good_edge_4)
 value_of_edges=value_of_edges+1;
end
if isequal(edge_north,good_edge_5)
 value_of_edges=value_of_edges+1;
end

%South
if isequal(edge_south,good_edge_1)
 value_of_edges=value_of_edges+1;
end
if isequal(edge_south,good_edge_2)
 value_of_edges=value_of_edges+1;
end
if isequal(edge_south,good_edge_3)
 value_of_edges=value_of_edges+1;
end
if isequal(edge_south,good_edge_4)
 value_of_edges=value_of_edges+1;
end
if isequal(edge_south,good_edge_5)
 value_of_edges=value_of_edges+1;
end

%East
if isequal(edge_east,good_edge_1)
 value_of_edges=value_of_edges+1;
end
if isequal(edge_east,good_edge_2)
 value_of_edges=value_of_edges+1;
end
if isequal(edge_east,good_edge_3)
 value_of_edges=value_of_edges+1;
end
if isequal(edge_east,good_edge_4)
 value_of_edges=value_of_edges+1;
end
if isequal(edge_east,good_edge_5)
 value_of_edges=value_of_edges+1;
end
   
end

