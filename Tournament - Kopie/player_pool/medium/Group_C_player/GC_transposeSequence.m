%  @brief Given an initial Othello sequence, this function mirrors it to one of the seven other
%  versions, returning a board which resulted from the exact same moves,
%  but in another symmetry direction.
% 
%  @author Martin Becker
%  @date 2011-Jan-15
%  @lastchange: bugfix transpose white<->black
% 
%  @callgraph
%  @callergraph
% 
% @param seq an alphanumeric even-length string of length 2*n the regular form
%     "([\w\d][\2\d])*", e.g. "F5d6C3d3C4" (Tiger opening).
% @param shallStartAt a char of length 2 indicating with which move the
%     sequence shall start after transposition.
% @retval seq the input argument, but transposed so that it starts with
%     'shallStartAt'
function [ seq ] = GC_transposeSequence( seq, shallStartAt )

len = numel(seq);
if (len < 2)
    return;
end

if (mod(len,2)~=0)
    warning([mfilename ': sequence corrupt (odd length)!']);
    return;
end
if isempty( isempty(shallStartAt))
    warning([mfilename ': last argument is empty!']);
    return;
end

isStartingFrom = lower(seq(1:2));
shallStartAt = lower(shallStartAt);

%% 1. sequence to coordinates with (row=0,col=0) between 4th and 5th columna and
%% row. D4=(-1,-1), E4=(-1,1), d5=(1,-1), e5=(1,1) 

coords = [seq(:,1:2:end); seq(:,2:2:end)]';
% make numeric
coords = int8(coords);

% make addresses relative to (0,0) as defined above
coords(:,2) = int8(coords(:,2) -  52);  % numeric rows
coords(:,1) = int8(coords(:,1) - 100);  % alpha columns
idx = find(coords<1);
coords(idx) = coords(idx)-1;
% cover the case when source is white -> horizontal mirroring does the job.
switch isStartingFrom
    case 'e3'
        coords(:,1) = -coords(:,1); % horiz. flip (columns)
        isStartingFrom = 'd3';
    case 'f4'
        coords(:,1) = -coords(:,1); % horiz. flip
        isStartingFrom = 'c4';
    case 'c5'
        coords(:,1) = -coords(:,1); % horiz. flip
        isStartingFrom = 'f5';
    case 'd6'
        coords(:,1) = -coords(:,1); % horiz. flip
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
                coords = fliplr(coords);  % switch row and col
            case 'c4'
                coords = -coords;         % quadrant diagonally
            case 'd3'
                coords = -fliplr(coords);
            otherwise
        end
    case 'e6'
        switch shallStartAt
            case 'f5'
                coords = fliplr(coords);  % switch row and col
            case 'c4'
                coords = -fliplr(coords);
            case 'd3'
                coords = -coords;
            otherwise
        end        
    case 'c4'
        switch shallStartAt
            case 'e6'
                coords = -fliplr(coords);
            case 'f5'
                coords = -coords;
            case 'd3'
                coords = fliplr(coords);
            otherwise
        end        
    case 'd3'
        switch shallStartAt
            case 'e6'
                coords = -coords;
            case 'c4'
                coords = fliplr(coords);
            case 'f5'
                coords = -fliplr(coords);
            otherwise
        end        
    otherwise
end

% this is for the target being white. is same as horizontally mirrored
% black target.
if flip_horiz_after
    coords(:,1) = -coords(:,1); % horiz. flip
end

% coords back to sequences.
idx = find(coords<1);
coords(idx) = coords(idx)+1;
coords(:,2) = coords(:,2) +  52;    % row, numeric
coords(:,1) = coords(:,1) + 100;    % column, alpha

coords = char(coords);
seq = reshape(coords',1,len);