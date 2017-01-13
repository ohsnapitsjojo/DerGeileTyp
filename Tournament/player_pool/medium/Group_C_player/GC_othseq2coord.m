%  @brief Translates an initial Othello board move sequence to a
%  2D-coordinate sequence.
%
%  @author Martin Becker
%  @date 2011-Jan-07
% 
%  @callgraph
%  @callergraph
% 
% input arguments
%   @param sequence an alphanumeric even-length string of length 2*n the regular form
%   "([\w\d][\2\d])*", e.g. "F5d6C3d3C4" (Tiger opening).
% 
%   @retval coords a n-by-2 matrix with coordinates.  Definition of the coordinates: upper left field A1 = (1,1), 
%   lower right field H8 = (8,8).
function [ coords ] = GC_othseq2coord( sequence )

len = numel(sequence);
if (~(rem(len,2)==0))
    error('sequence length must be even!');
end

% separate moves to x,y dimensions
coords = [sequence(:,2:2:end); sequence(:,1:2:end)]';
coords(:,2) = lower(coords(:,2));
% make numeric
coords = uint8(coords);
% make addresses
coords(:,1) = coords(:,1) - 48;
coords(:,2) = coords(:,2) - 96;