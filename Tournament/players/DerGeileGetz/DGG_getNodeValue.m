function v = DGG_getNodeValue(b, player)

b_weighted = [100000     -3000     1000     800     800      1000     -3000      100000;
                 -3000     -5000     -450    -500    -500      -455     -5000       -3000;
                  1000     -450         3       1       1         3      -450        1000;
                   800     -500         1       5       5         1      -500         800;
                   800     -500         1       5       5         1      -500         800;
                  1000     -450         3       1       1         3      -450        1000;
                 -3000     -5000     -450    -500    -500      -455     -5000       -3000;
                100000     -3000     1000     800     800      1000     -3000      100000];
   
% Modification of weights if a corner is occupied by us (X- and C- fields)
if(b(1,1) == player)
    b_weighted(2,1)=7500;
    b_weighted(1,2)=7500;
    b_weighted(2,2)=8500;
elseif(b(1,8) == player)
    b_weighted(1,7)=7500;
    b_weighted(2,8)=7500;
    b_weighted(2,7)=8500;
elseif(b(8,1) == player)
    b_weighted(7,1)=7500;
    b_weighted(8,2)=7500;
    b_weighted(7,2)=8500;
elseif(b(8,8) == player)
    b_weighted(7,8)=7500;
    b_weighted(8,7)=7500;
    b_weighted(7,7)=8500;
end

% Modification of regions around the corners
% North-West
if(b(1,1) == player)
	if(b(2,1) == player && b(1,2) == player)
		if(b(3,1) == player && b(2,2) == player && b(1,3) == player)
			b_weighted(3,2)=800;
			b_weighted(2,3)=800;
		end
	end
end

% North-East
if(b(1,8) == player)
	if(b(1,7) == player && b(2,8) == player)
		if(b(1,6) == player && b(2,7) == player && b(3,8) == player)
			b_weighted(2,6)=800;
			b_weighted(3,7)=800;
		end
	end
end

% South-West
if(b(8,1) == player)
	if(b(7,1) == player && b(8,2) == player)
		if(b(6,1) == player && b(7,2) == player && b(8,3) == player)
			b_weighted(6,2)=800;
			b_weighted(7,3)=800;
		end
	end
end

% South-East
if(b(8,8) == player)
	if(b(8,7) == player && b(7,8) == player)
		if(b(8,6) == player && b(7,7) == player && b(6,8) == player)
			b_weighted(7,6)=800;
			b_weighted(6,7)=800;
		end
	end
end

% Summary of alle weights
v = sum(b_weighted(b == player));

end