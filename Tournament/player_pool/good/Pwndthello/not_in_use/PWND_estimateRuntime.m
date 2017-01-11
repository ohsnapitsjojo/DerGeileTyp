%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script for estimating negamax runtime for different depths, not used in
% the player. Experiments with different boards showed that the average 
% time multiplier obtained by random boards here is rather an upper bound 
% for the increase in time. In general, the opponent tries to limit the 
% ones mobility, thus decreasing the size of the search tree.
% In the actual player, this is used by decreasing the time multiplier
% towards the end of the game when estimating the time of the next move,
% since in the possibilities towards the end are limited.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear all; clc;
%% Starting board
board = zeros(8);
board(4,4) = 1;
board(4,5) = -1;
board(5,4) = -1;
board(5,5) = 1;

%% Initializations
boardvec = [8 10 15 18 24];
Boards = zeros(8,8,length(boardvec));
depthvec = 1:8;

%% Construct boards with amount of stones in boardvec
for k = 1:length(boardvec)
    numstones = 4;
    color = -1;
    disp(['Constructing board ' num2str(k) ' with ' num2str(boardvec(k)) ' stones']);
    while numstones < boardvec(k)
        color = color*-1;
        [~, B] = PWND_findAllowedPositions(board, color);
        board = B(:,:,ceil(rand*size(B,3)));
        numstones = sum(sum(board~=0));
        Boards(:,:,k) = board;
    end
end

%% Call Negamax for each board and search depth
tMat= zeros(size(Boards,3),length(depthvec));
for k = 1:size(Boards,3)
    for j = 1:length(depthvec)
        disp(['Calculating for Board ' num2str(k) ' and depth ' num2str(depthvec(j))])
        tic;
        [~, b] = PWND_negamaxPruning(Boards(:,:,k), 1, -inf, +inf, depthvec(j));
        tMat(k,j) = toc;
    end
end

%% Calculate the factor of increase in time
factorMat = zeros(size(tMat,1),size(tMat,2)-1);
for k = 1:size(tMat,1)
    for j = 2:size(tMat,2)
        factorMat(k,j-1) = tMat(k,j)/tMat(k,j-1);
    end
end

%% Plot the results
plot(depthvec,tMat);
xlabel('Search depth');
ylabel('time [s]');
legendCell = cellstr(num2str(boardvec', 'N = %-d'));
legend(legendCell);

factor = mean(mean(factorMat));
disp(['Average time multiplier of ' num2str(factor) ' for greater search depth']);