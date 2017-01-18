%  @brief Given an Othello board, this function mirrors it to one of the three other
%  versions, returning a board which resulted from the exact same moves,
%  but in another symmetry direction.
% 
%  E.g. the tiger opening can be "F5d6C3d3C4". If it is played in another
%  direction, starting with "e6" instead of "f5", the sequence is: "E6...(TBD)"
% 
%  Tranposing black to white is also supported now.
%  
%  This function can be used to significantly reduce the space of a
%  dictionary, by e.g. giving only moves resulting from starts at "f5". The
%  other three directions are just symmetric around the board center.
% 
%  @author Martin Becker
%  @date 2011-Jan-14
% 
%  @callgraph
%  @callergraph
% 
% @param board an 8-by-8 matrix
function [ board ] = GC_transposeBoard( board, isStartingFrom, shallStartAt )

if isempty(isStartingFrom) || isempty(shallStartAt)
    warning([mfilename ': one of the latter two arguments is empty!']);
    return;
end

isStartingFrom = lower(isStartingFrom);
shallStartAt = lower(shallStartAt);

% cover the case when source is white -> horizontal mirroring does the job.
switch isStartingFrom
    case 'e3'
        board = fliplr(board);
        isStartingFrom = 'd3';
    case 'f4'
        board = fliplr(board);
        isStartingFrom = 'c4';
    case 'c5'
        board = fliplr(board);
        isStartingFrom = 'f5';
    case 'd6'
        board = fliplr(board);
        isStartingFrom = 'e6';        
    otherwise
end

% cover the case when target is white -> horizontal mirroring after
% operation on black.
flip_horiz_after = 0;
switch shallStartAt
    case 'e3'
        flip_horiz_after = 1;
        shallStartAt = 'd3';
    case 'f4'
        flip_horiz_after = 1;
        shallStartAt = 'c4';
    case 'c5'
        flip_horiz_after = 1;
        shallStartAt = 'f5';
    case 'd6'
        flip_horiz_after = 1;
        shallStartAt = 'e6';        
    otherwise
end

%% OPERATIONS TO TRANSPOSE A BLACK OPENING TO SOME OTHER BLACK OPENING
switch isStartingFrom
    case 'f5'
        switch shallStartAt
            case 'e6'
                board = fliplr(rot90(board,3));
            case 'c4'
                board = rot90(board,2);
            case 'd3'
                board = fliplr(rot90(board));
            otherwise
        end
    case 'e6'
        switch shallStartAt
            case 'f5'
                board = flipud(rot90(board));
            case 'c4'
                board = flipud(rot90(board,3));
            case 'd3'
                board = rot90(board, 2);
            otherwise
        end        
    case 'c4'
        switch shallStartAt
            case 'e6'
                board=fliplr(rot90(board));
            case 'f5'
                board = rot90(board, 2);
            case 'd3'
                board = fliplr(rot90(board,3));
            otherwise
        end        
    case 'd3'
        switch shallStartAt
            case 'e6'
                board = rot90(board, 2);
            case 'c4'
                board = flipud(rot90(board));
            case 'f5'
                board = flipud(rot90(board,3));
            otherwise
        end        
    otherwise
end

% this is for the target being white. is same as horizontally mirrored
% black target.
if flip_horiz_after
    board = fliplr(board);
end