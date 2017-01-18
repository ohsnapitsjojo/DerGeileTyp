% @brief dirty little helper - no doc for that ugly snippet.
% @author Martin Becker
% @date 2011-Jan-07
function GC_plotWrapper(board, title)
color = 1;
set (gcf, 'Name', title);
clf;
[mine_coord_row, mine_coord_col] = find(board == color);
[opponent_coord_row, opponent_coord_col] = find(board == -color);
opponent_coord = [opponent_coord_row';opponent_coord_col']; % row 1: row coord, row 2: col coord.
mine_coord = [mine_coord_row'; mine_coord_col']; 
GC_plotBoard(mine_coord, opponent_coord);