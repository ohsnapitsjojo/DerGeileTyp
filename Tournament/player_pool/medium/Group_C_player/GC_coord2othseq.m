%  @brief Translates a 2D-coordinate sequence into an Othello board move
%  sequence. Inverse of othseq2coord().
%  
% 
%  @author Martin Becker
%  @date 2011-Jan-14
% 
%  @callgraph
%  @callergraph
% 
% return arguments
%   @retval sequence an alphanumeric even-length string of length 2*n the regular form
%   "([\w\d][\2\d])*", e.g. "F5d6C3d3C4" (Tiger opening).
% 
%   @param coords a 2-by-n matrix with coordinates.  Definition of the coordinates: upper left field A1 = (1,1), 
%   lower right field H8 = (8,8).
function [ sequence ] = GC_coord2othseq( coords )

[r,c]=size(coords);

% make alphanum
coords(1,:) = coords(1,:) + 48; % row    -> numeric
coords(2,:) = coords(2,:) + 96; % column -> alpha
coords=char(flipud(coords));

% stick together to a sequence
sequence = reshape(coords, 1, r*c);
