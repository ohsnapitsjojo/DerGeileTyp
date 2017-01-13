%  @file test_getValidPositions_2.m
%  @brief Tests getValidPositions_LGS_nofunc() with a given Othello
%  sequence.
% 
%  More detailed description.
%  @author: Martin Becker
%  @date 2011-Jan-15
%  @callgraph
%  @callergraph
clear all; close all; clc;

% ------ settings ----------------------------------------------------------
color=-1;                   % my color (next move after sequence)
startColor = 1;             % -1=black begins, +1=white begins
sequence = 'f4d3c5';        % sequence
roundno = 1;                % round number. can be used to test dictionary.
% --------------------------------------------------------------------------

if (~isempty(sequence))
    coords = GC_othseq2coord(sequence);            % sequence to coordinates
    thisBoard = GC_simMove(coords,startColor);     % coordinates to board
else
    thisBoard = GC_simMove();                      % returns the init board -> why not :)
end

figure; GC_plotWrapper(thisBoard(:,:,end), 'Initial Board');

switch color
    case 1
        strcolor = 'white';
    case -1
        strcolor = 'black';
    otherwise
        strcolor = 'unknown';
end
disp(['Now it shall be ' strcolor '''s (' num2str(color) ') turn.']);

% get all possible moves for this board when it is color's turn.
[possibleBoards,newdisks,numReversed] = GC_getValidPositions(thisBoard(:,:,end),color,roundno, sequence);

numMoves = numel(numReversed);

if (numMoves > 0)
    disp([num2str(numMoves) ' moves possible for the given board and color.']);
    for k = 1:numMoves
        figure; GC_plotWrapper(possibleBoards(:,:,k), ['Move #' num2str(k) ': set disk to ' char(newdisks(2,k)+96) num2str(newdisks(1,k)), ', reverses ' num2str(numReversed(k))]);
    end
else
    disp('No moves possible for the given color and board.');
end

