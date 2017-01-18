function depth = gdepth(b, time)
%% Determine Depth

%% 
if time < 5
    depth = 2;
    return;
elseif time < 15
    depth = 3;
    return;
end;

%% 
empty = sum(sum(b==0));
if empty > 55
    depth = 5;
    return;
elseif empty <= 10

    depth = inf;
    return;
elseif empty <= 15
    depth = 6;
    return;
end

%% 
depth = 4;
end
