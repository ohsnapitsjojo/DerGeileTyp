%  @brief Translates a hex string from GC_board2id() to an Othello board.
%
%  @author Martin Becker
%  @date 2011-Jan-06
% 
%  @callgraph
%  @callergraph
% 
% input arguments
%   @retval board matrix 8-by-8 representing an Othello game board. fields
%   with 0 are empty, +1 and -1 are both players, respectively.
% 
%   @param bid board id, a char string of length 32 with hex numbers.
function [ board] = GC_id2board( bid )

set_id = bid(1:16);
col_id = bid(17:32);

col_id_hi = hex2dec(col_id(1:8));
col_id_lo = hex2dec(col_id(9:16));
set_id_hi = hex2dec(set_id(1:8));
set_id_lo = hex2dec(set_id(9:16));

col_coord = false(1,64);
col_coord(1,1:32) = dec2binvec(col_id_lo,32);
col_coord(1,33:64) = dec2binvec(col_id_hi,32);
col_coord = col_coord';

set_coord = false(1,64);
set_coord(1,1:32) = dec2binvec(set_id_lo,32);
set_coord(1,33:64) = dec2binvec(set_id_hi,32);
set_coord = set_coord';

set_coord = (reshape(set_coord,8,8)); %~= 0);
col_coord = (reshape(col_coord,8,8)); % > 0);

% make board again.
board = zeros(8);
board(set_coord) = -1;
board(col_coord) = 1;