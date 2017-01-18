%  @file test_transposeBoard.m
%  @brief Tests GC_transposeBoard().
% 
%  @author: Martin Becker
%  @date 2011-Jan-06
%  @callgraph
%  @callergraph
clear all; close all; clc;

% disk density
p = 0.7;
color = 1;

% generate any board - make sure both players are present.
% mine_coord=[];
% opponent_coord=[];
% while (isempty(mine_coord) | isempty(opponent_coord))
%     board = (rand(8)>p);            % me 
%     board = board - (rand(8)>p);    % opp. Intersections are erasing themselves this way.

load board_tiger.mat    %tiger opening - a known pattern.

    [mine_coord_row, mine_coord_col] = find(board == color);
    [opponent_coord_row, opponent_coord_col] = find(board == -color);
    opponent_coord = [opponent_coord_row';opponent_coord_col']; % row 1: row coord, row 2: col coord.
    mine_coord = [mine_coord_row'; mine_coord_col']; 
%end

GC_plotWrapper(board, 'original');

board_d3 = GC_transposeBoard(board, 'f5','d3'); 
GC_plotWrapper(board_d3,'Mirrored to D3');
board_d3f5 = GC_transposeBoard(board_d3, 'd3','f5'); 
GC_plotWrapper(board_d3f5,'d3 back to f5');

board_c4 = GC_transposeBoard(board, 'f5','c4'); 
GC_plotWrapper(board_c4,'Mirrored to C4');
board_c4f5 = GC_transposeBoard(board_c4, 'c4','f5'); 
GC_plotWrapper(board_c4f5,'C4 back to f5');

board_e6 = GC_transposeBoard(board, 'f5','e6'); 
GC_plotWrapper(board_e6,'Mirrored to E6');
board_e6e5 = GC_transposeBoard(board_e6, 'e6','f5'); 
GC_plotWrapper(board_e6e5, 'e6 back to f5');



