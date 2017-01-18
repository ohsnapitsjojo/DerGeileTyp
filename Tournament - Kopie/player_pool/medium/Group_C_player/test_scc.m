% @brief find empty areas in othello board
% @author Martin Becker
% @date 2011-Jan-28
clc; clear all; close all;

board = (rand(8)<0.5) - (rand(8)>0.5);
GC_plotWrapper(board, 'Board');

board = ones(8);
board(1,1:2)=0;

emptyAreas = (board==0);

[L,num]=bwlabel(emptyAreas, 4)
for k = 1:num
    that = (L==k);
    numFree = sum(sum(that));
    figure; GC_plotWrapper(that, ['component=' num2str(k) ', numFree=' num2str(numFree)]);
end
