function matchPoints = findMoves(b, color)
% Ferdinand
% Search possible moves; Output is a [n x 2] matrix with field coordinates
% [row col]
% status: beta, tested in combination with makeMove() (5.6.12, 00.52)
A = b;
%% find opponents tokens
%idx=find(b==-color);
[y x]=find(b==-color);

if ~isempty(y)
    k = 1;
end    
%% mark free fields near opponents tokens
while k <= length(y)
    % boarder-check: the loop interval must not contain the index 0
    iLoop = y(k)-1:1:y(k)+1;
    iLoop(iLoop == 0) = [];
    iLoop(iLoop > 8) = [];
    for i = iLoop
        jLoop = x(k)-1:1:x(k)+1;
        jLoop(jLoop == 0) = [];
        jLoop(jLoop > 8) = [];
        for j = jLoop
            if b(i,j) == 0
                b(i,j) = 2;
            end
        end
    end
    k = k+1;
end

%% find possible fields for a move
[y x]=find(b==2);
if ~isempty(y)
    k = 1;
end
% refresh board after finding free fields
b = A;
% declare matrix for matches, remove entries with zero after procedure
matchPoints = zeros(15,2);
matchCount = 1;
while k <= length(y)
    % boarder-check: the loop interval must not contain the index 0
    iLoopVec = y(k)-1:1:y(k)+1;
    iLoopVec(iLoopVec == 0) = [];
    iLoopVec(iLoopVec > 8) = [];
    for i = iLoopVec
        jLoopVec = x(k)-1:1:x(k)+1;
        jLoopVec(jLoopVec == 0) = [];
        jLoopVec(jLoopVec > 8) = [];
        for j = jLoopVec
            if b(i,j) == -color
                % check if own tokens lie behind this one
                % 8 possible directions
                % determine direction
                dir = [i j]-[y(k) x(k)];
                % recursive check
                match = lookBehind(b, [i j]+dir, color, dir);
                if length(match) > 1
                    matchPoints( matchCount, 1) = y(k);
                    matchPoints( matchCount, 2) = x(k);
                    matchCount = matchCount + 1;
                end
            end
        end
    end
    k = k+1;
end
matchPoints=matchPoints(matchPoints ~= 0);
matchPoints=reshape(matchPoints,[],2);

%% inline function to search for own tokens
function match = lookBehind(b, point, color, dir)
% boarder-check necessary
if any(point+dir<=0) || any(point+dir>8)
    match = 0;
elseif b(point(1), point(2)) == color
    match = point;
elseif b(point(1), point(2)) == 0
    match = 0;
else
    match = lookBehind(b,point+dir,color,dir);
end