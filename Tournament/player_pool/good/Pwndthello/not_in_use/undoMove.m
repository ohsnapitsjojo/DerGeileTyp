function b = undoMove( b, color, m, n )
% Ferdinand, 11.6.
% beta, did some tests only

% clear last field
b( m, n ) = 0;
% switch tokens
% for it, find direction of point (m,n), where there are only tokens with
% own color in a line
btemp = b;
%% mark own fields near last placed token
% boarder-check: the loop interval must not contain the index 0
iLoop = m-1:1:m+1;
iLoop(iLoop == 0) = [];
iLoop(iLoop > 8) = [];
for i = iLoop
    jLoop = n-1:1:n+1;
    jLoop(jLoop == 0) = [];
    jLoop(jLoop > 8) = [];
    for j = jLoop
        if b(i,j) == color
            btemp(i,j) = 2;
        end
    end
end

%% check for every possible direction which tokens were switched
[ M N ] = find(btemp == 2);
for i = 1:numel(btemp(btemp == 2))
    dirVec = [M(i)-m N(i)-n ];
    % only tokens with own color should be in a line
    %match = lookBehind(b, [m n]+dirVec, color, dirVec,0);
    if b( m+2*dirVec(1), n+2*dirVec(2) ) == color
        % switch tokens
        linelength = 1;
        while b(m+(1+linelength)*dirVec(1),n+(1+linelength)*dirVec(2)) == color
            b(m+(linelength)*dirVec(1), n+(linelength)*dirVec(2)) = -color;
            linelength = linelength + 1;
        end
    end
end
