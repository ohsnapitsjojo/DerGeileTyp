%  @brief Translates an Othello board to a unique hex string.
% 
%  @author Martin Becker
%  @date 2011-Jan-06
% 
%  @callgraph
%  @callergraph
% 
% input arguments
%   @param board matrix 8-by-8 representing an Othello game board. fields
%   with 0 are empty, +1 and -1 are both players, respectively.
% 
%   @retval bid board id, a char string of length 32 with hex numbers.
function [ bid] = GC_board2id( board )

% make a logical vector encoding the color
% color encoding: logical 1 = +1, logical 0 = -1 or no disk.
%col_coord = reshape([pos_coord_row, pos_coord_col],64,1);
set_coord = (reshape(board,64,1) ~= 0);
col_coord = (reshape(board,64,1) > 0);

%% now translate both 64-element logical vectors into two uint64 numbers.
% That awful function binvec2dec() can only handle up to 54-element
% vectors, hence the split here.
col_id_lo = uint32(binvec2dec(col_coord(1:32)'));
col_id_hi = uint32(binvec2dec(col_coord(33:64)'));
set_id_lo = uint32(binvec2dec(set_coord(1:32)'));
set_id_hi = uint32(binvec2dec(set_coord(33:64)'));

% hex
col_id = [dec2hex(col_id_hi,8) dec2hex(col_id_lo,8)];
set_id = [dec2hex(set_id_hi,8) dec2hex(set_id_lo,8)];

bid = [set_id, col_id];



