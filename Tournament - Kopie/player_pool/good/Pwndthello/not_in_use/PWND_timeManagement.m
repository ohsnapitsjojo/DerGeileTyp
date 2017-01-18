function depth = PWND_timeManagement(b,color,time_left)
disp(mfilename);
% Estimates a search depth depending on left time budget
brf = 7; % approximized branching factor, from literature
[numturn] = PWND_getGamestate(b,[30 52]);

%% Memorizing last search depth
persistent lastdepth
if numturn < 3
    lastdepth = 5;
end

%% Timebudget for a move
time_move = time_left / (61 - numturn) ;
test_depth = max(2,lastdepth-1);

%% Perform alpha-beta-search to measure the time
timestart = tic;
[~] = PWND_negamaxPruning(b, color, -inf, +inf, test_depth,test_depth);
timestop = toc(timestart);
add_depth = 1;
while 1
    time_factor = brf^(test_depth+add_depth+1) / brf^test_depth;
    if timestop * time_factor > time_move
        break;
    end
    add_depth = add_depth + 1;
end
lastdepth = test_depth + add_depth;
disp(['Search depth: ' num2str(lastdepth) ]);
depth = lastdepth;