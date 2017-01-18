board = zeros(8);    
board(3:6,3:6) = [ 0 , -1, 0, 0;   
              0, -1 , 1, 1
              1 , -1, 1, 0
              0, -1, 0, 0];
color = -1;
depth = 6; 
round_no = 9;
gameSequence = 'f5d6c3d3c4';
alpha = 3;
beta = 12;
[bestpos, best, diskSet] = GC_makeMove(board, color, round_no, depth, gameSequence, alpha, beta)