function value_of_board = ValueOfBoard(b,color)

%% Define Look-Up-Table for the board to improve the result

% Weighting of board positions according to http://othellomaster.com/OM/Report/HTML/report.html
% We have adapted the corners and the center fields

weighted_board=[100000     -3000     1000     800     800      1000     -3000      100000;
                 -3000     -5000     -450    -500    -500      -455     -5000       -3000;
                  1000     -450         3       1       1         3      -450        1000;
                   800     -500         1       5       5         1      -500         800;
                   800     -500         1       5       5         1      -500         800;
                  1000     -450         3       1       1         3      -450        1000;
                 -3000     -5000     -450    -500    -500      -455     -5000       -3000;
                100000     -3000     1000     800     800      1000     -3000      100000];
   
% Modification of weights if a corner is occupied by us (X- and C- fields)
if(b(1,1)==color)
    weighted_board(2,1)=7500;
    weighted_board(1,2)=7500;
    weighted_board(2,2)=8500;
elseif(b(1,8)==color)
    weighted_board(1,7)=7500;
    weighted_board(2,8)=7500;
    weighted_board(2,7)=8500;
elseif(b(8,1)==color)
    weighted_board(7,1)=7500;
    weighted_board(8,2)=7500;
    weighted_board(7,2)=8500;
elseif(b(8,8)==color)
    weighted_board(7,8)=7500;
    weighted_board(8,7)=7500;
    weighted_board(7,7)=8500;
end

% Modification of regions around the corners
% North-West
if(b(1,1)==color)
	if(b(2,1)==color && b(1,2)==color)
		if(b(3,1)==color && b(2,2)==color && b(1,3)==color)
			weighted_board(3,2)=800;
			weighted_board(2,3)=800;
		end
	end
end

% North-East
if(b(1,8)==color)
	if(b(1,7)==color && b(2,8)==color)
		if(b(1,6)==color && b(2,7)==color && b(3,8)==color)
			weighted_board(2,6)=800;
			weighted_board(3,7)=800;
		end
	end
end

% South-West
if(b(8,1)==color)
	if(b(7,1)==color && b(8,2)==color)
		if(b(6,1)==color && b(7,2)==color && b(8,3)==color)
			weighted_board(6,2)=800;
			weighted_board(7,3)=800;
		end
	end
end

% South-East
if(b(8,8)==color)
	if(b(8,7)==color && b(7,8)==color)
		if(b(8,6)==color && b(7,7)==color && b(6,8)==color)
			weighted_board(7,6)=800;
			weighted_board(6,7)=800;
		end
	end
end

% Summary of alle weights
value_of_board = sum(weighted_board(b==color));
