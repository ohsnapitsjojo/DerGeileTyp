%  @brief Given a snapshot of a game board, this function returns a set of possible constellations after 
%  one ply and indicates where to place a disk to get there. Hence this function computes both possible 
%  places for a new disk AND the resulting effect on the board.
% 
%  This implementations uses vectors to evaluate the positions and
%  effects AND does not use function calls to speed up things a little.
% 
%  @author Martin Becker
%  @date 2011-Jan-26
% 
%  @callgraph
%  @callergraph
% 
% input arguments
%   @param board the playing board described by an m-by-n matrix.
%   @param color - positions in 'board' where the value equals 'color' are
%       assumed
%       to be my disks. Elements with zero are assumed to be free, whereas
%       others are all opponents. WARNING: -1 is mapped to BLACK and +1 is
%       mapped to WHITE. This mapping is fixed, but allows to either let
%       black or white start, unlinke traditional Othello game, where
%       always white has to start.
%   @param round_no - the number of the current round. Used to decide whether special opening dictionary moves are incorporated. 
%   @param gameSequence a alphanumeric sequence indicating the othello
%       moves done up to now. If this argument is passed empty, then the
%       dictionary is SUPPRESSED. When given a move sequence, the
%       dictionary will match that and return only one good move, if it
%       knows one. If only bad moves are known, these are subtracted from
%       the result tuple set of (possibleBoards,disksNew,numDisksRev). 
% 
% return value:
%   @retval possibleBoards  a matrix the same size of board with a third
%       dimension P. Each matrix along dimension P represents a snapshot of one
%       possible move. For each move there exists a matrix in P. If empty, no
%       moves are possible.
%       Fields marked with 0 are empty, boards with 'color' is me, boards with
%       '-color' is the opponent. Additionally, 'won' disks are represented by
%       2*color. The newly placed disk is indicated by 3*color.
%       Note that the sign can be used to only distinct between opponent's and
%       own disks, the 'amplitude' of the actual boards can be disregarded using 
%       relops this way, if not needed.
%   @retval disksNew a 2-by-P matrix, for each board constellation given in
%       possibleBoards the according newly set disk is given as a coordinate
%       here. element (1,1) is the row coordinate, element (1,2) is the
%       column coordinate.
%   @retval numDisksRev for each possibleBoard/each disksNew there is
%       returned a value, indicating how many of the opponent's disks are
%       reversed when that particular move is chosen. Note that of a
%       dictionary move is used, this number always equals 1.
% @comment did a lot of copy n paste, because delegating reoccurring tasks
%     to functions takes time (function calls...)
function [ possibleBoards, disksNew, numDisksRev, dict_flag ] = GC_getValidPositions( board , color, round_no, gameSequence)

persistent use_dictionary;

if (isempty(use_dictionary) || (round_no == 1)), use_dictionary = 1; end; % begin of game: use dict.

[mine_coord_row, mine_coord_col] = find(board == color);
[opponent_coord_row, opponent_coord_col] = find(board == -color);
opponent_coord = [opponent_coord_row';opponent_coord_col']; % row 1: row coord, row 2: col coord.
mine_coord = [mine_coord_row'; mine_coord_col'];

% sanity check
if (isempty(mine_coord) || isempty(opponent_coord))
    warning ([ mfilename ': No opponent on field of none of my disks on field. The game must be over already.']);    %% REMOVE: the game server must look after that!
    possibleBoards = []; disksNew = []; numDisksRev = [];
    dict_flag = use_dictionary; % ADD: gerri
    return;
end

% look in dictionary for known constellations, if it is enabled. Is enabled
% by default at game start. Disables itself when the constellation is
% unknown. 
% For known constellations a set of recommended moves and a set of moves to
% be avoided (badDisks) are returned.

if (use_dictionary && ~strcmp(gameSequence,'')) % added emptyness check here, because otherwise a caller which needs the full possibilities and doesn't have a game sequence would unintentionally disable the dictionary.
    %disp([mfilename ': Calling dictionary...']);
    [goodDisk, goodBoard, badDisks] = GC_queryDictionary(board, color, round_no, gameSequence);

    if (isempty(goodBoard) && isempty(badDisks))
        % running out of entries or in the middle of the game -> don't call dictionary anymore.
        use_dictionary = 0;
	disp([mfilename ': dictionary off (no matching entries).']);
    end    
    
    if ~isempty(goodBoard)
        % return good move and done.
        possibleBoards = goodBoard;
        disksNew = goodDisk; 
        numDisksRev = 1;    % fake, because if there exists only one possibility this content doesn't matter
        
        disp([mfilename ': dictionary returned a good move.']);
        
        dict_flag = use_dictionary; % ADD: gerri

        return;
    end
else
    badDisks = []; % needed at the end
end

% ### NO DICTIONARY OR DICTIONARY DOES NOT KNOW A GOOD MOVE  

% set callback for merging moves with side effects: if the same fields on
% two boards have different values, always take mine.
if (color > 0)
    mine_win = @max;
else
    mine_win = @min;
end

%% calc difference vectors from each of my disks to each of opponents.
% 2-by-m-by-n matrix. Row1: row coords, row2: col coords. along dimension
% m: sets of such vectors. along dimension n: replicated 2-by-m-matrix.
refdisk = permute(mine_coord, [1 3 2]);
% now: m = replicated 2-by-m-matrix. n=sets of such vectors.
refdisk = repmat(refdisk,[1, size(opponent_coord,2), 1]);
% e.g. (:,3,4) = difference vector of opponent's 3rd disk to my 4th disk
%      (1,3,4) = row difference of opponent's 3rd disk to my 4th disk
%      (2,3,4) = col difference of opponent's 3rd disk to my 4th disk
diff_opponent = repmat(opponent_coord, [1 1 size(refdisk,3)]) - refdisk;
dist_opponent = sqrt(diff_opponent(1,:,:).^2 + diff_opponent(2,:,:).^2);

% forget about my disks (=z planes) which do not have adjacent opponents.
    adjacents = min(dist_opponent,[],2) < 1.5;
    % remove all entries of my disks where the least distance is greater
    % than sqrt(2) ("no neighbour", means all horizontal 2 or vertical  2 and diagonal > 1 are rejected).
    idxkeeponly = find(adjacents(1,1,:) > 0); % keep only the z-planes (=my disks) where a direct neighbour is present
    dist_opponent = dist_opponent(:,:,idxkeeponly);
    diff_opponent = diff_opponent(:,:,idxkeeponly);

    % we now found ALL out disks which are neighbored directly by an
    % opponent in any direction.
    mine_coord_haveNeigh = mine_coord(:,idxkeeponly);

    num_move_candidates = size(mine_coord_haveNeigh,2);
    
    % this variable will save a set of possible boards after
    % applying each possible move.
    possibleBoards = [];
    
    % same order as board_moves_diff: indicates the newly positioned disk.
    disksNew = [];
    
    numDisksRev=[];
    
%% split up z-planes (=move candidates) and for each check h,v,d disks. We
% do not know, yet, in which direction the adjacent disk is placed.
    for z = 1:num_move_candidates;
        %disp(['move cand. ' num2str(z) ' of ' num2str(num_move_candidates), ': x,y=[' num2str(mine_coord_haveNeigh(2,z)) ', ' num2str(mine_coord_haveNeigh(1,z)) ']']);

        % is ANY disk horizontally there?
        idx = find(diff_opponent(1,:,z)==0);    % get ALL indexes nevertheless, to scale down subsequent searches.
        if (~isempty(idx))

            % horizontally left - do prefiltering before a loop goes over the fields...
            if (~isempty(find(diff_opponent(1,idx,z)==0 & diff_opponent(2,idx,z)== -1,1)))    % find all horiz which are left adjacent                
                % ################### GET A TRAP #####################      
                %vecdir = [0;-1];
                modBoard = board;  % the board resulting from a trap    
                valid = 0;        
                revs = 0; 
                crow = mine_coord_haveNeigh(1,z); ccol = mine_coord_haveNeigh(2,z);
                lrow = crow;
                while true               
                    ccol = ccol - 1;
                    %crow = crow + 0;
                    %if (crow == 0 || crow == 9 || ccol ==0 || ccol == 9) , break; end;        
                    if (ccol == 0) , break; end;        
                    %lrow = crow; lcol = ccol;
                    lcol = ccol;
                    modBoard (crow, ccol) = color;   
                    switch board(crow,ccol)
                        case 0
                        valid = 1;                            
                        break;    % breaks the WHILE, not the switch!        
                        case color
                        break;            
                        otherwise    
                        revs = revs + 1;
                    end
                end
                % ################### HAVE TRAP ######################
                % save modified board and set disk (if present)
                if (valid)
                    % first check whether this disk is already found (this implies this
                    % disk causes a side effect, which already has been listed as a
                    % possible move). If so, combine the two moves to
                    % one big move with side effect.
                    if isempty(disksNew) 
                        relatedBoardIDX=[]; 
                    else 
                        relatedBoardIDX = find(disksNew(1,:) == lrow & disksNew(2,:) == lcol, 1);
                    end
                    if (isempty(relatedBoardIDX))
                        % normal move
                        disksNew = cat(2,disksNew, [lrow;lcol]);
                        possibleBoards = cat(3, possibleBoards, modBoard);         
                        numDisksRev = cat(2,numDisksRev,revs);
                    else
                        % one with side effects
                        % warning(['disk [' num2str(disksNew(1,1)) ';' num2str(disksNew(2,1)) '] already found (duplicate). Combining both boards.']);   % DEBUG MESSAGE - REMOVE!
                        possibleBoards(:,:,relatedBoardIDX) = mine_win(possibleBoards(:,:,relatedBoardIDX), modBoard);                                
                        numDisksRev(relatedBoardIDX) = numDisksRev(relatedBoardIDX) + revs;
                    end        
                end
            end
            % horizontally right
            if (~isempty(find(diff_opponent(1,idx,z)==0 & diff_opponent(2,idx,z)==1 ,1)))
                % ################### GET A TRAP #####################
                %vecdir = [0;1];                
                modBoard = board;  % the board resulting from a trap    
                valid = 0;        
                revs = 0; 
                crow = mine_coord_haveNeigh(1,z); ccol = mine_coord_haveNeigh(2,z);
                lrow = crow;
                while true               
                    ccol = ccol + 1;
                    %crow = crow + 0;
                    %if (crow == 0 || crow == 9 || ccol ==0 || ccol == 9) , break; end;        
                    if (ccol == 9) , break; end;        
                    %lrow = crow; lcol = ccol;
                    lcol = ccol;
                    modBoard (crow, ccol) = color;   
                    switch board(crow,ccol)
                        case 0
                        valid = 1;                            
                        break;    % breaks the WHILE, not the switch!        
                        case color
                        break;            
                        otherwise    
                        revs = revs + 1;
                    end
                end
                % ################### HAVE TRAP ######################
                % save modified board and set disk (if present)
                if (valid)
                    % first check whether this disk is already found (this implies this
                    % disk causes a side effect, which already has been listed as a
                    % possible move). If so, combine the two moves to
                    % one big move with side effect.
                    if isempty(disksNew) 
                        relatedBoardIDX=[]; 
                    else 
                        relatedBoardIDX = find(disksNew(1,:) == lrow & disksNew(2,:) == lcol, 1);
                    end
                    if (isempty(relatedBoardIDX))
                        % normal move
                        disksNew = cat(2,disksNew, [lrow;lcol]);
                        possibleBoards = cat(3, possibleBoards, modBoard);         
                        numDisksRev = cat(2,numDisksRev,revs);
                    else
                        % one with side effects
                        % warning(['disk [' num2str(disksNew(1,1)) ';' num2str(disksNew(2,1)) '] already found (duplicate). Combining both boards.']);   % DEBUG MESSAGE - REMOVE!
                        possibleBoards(:,:,relatedBoardIDX) = mine_win(possibleBoards(:,:,relatedBoardIDX), modBoard);                                
                        numDisksRev(relatedBoardIDX) = numDisksRev(relatedBoardIDX) + revs;
                    end        
                end
            end
        end

        
        % vertically up (DEcreasing row coord)
        idx = find(diff_opponent(2,:,z)==0);   
        if (~isempty(idx))
            if (~isempty(find(diff_opponent(2,idx,z)==0 & diff_opponent(1,idx,z)==-1,1)))
                % ################### GET A TRAP #####################
                %vecdir = [-1;0];                
                modBoard = board;  % the board resulting from a trap    
                valid = 0;        
                revs = 0; 
                crow = mine_coord_haveNeigh(1,z); ccol = mine_coord_haveNeigh(2,z);
                lcol = ccol;
                while true               
                    %ccol = ccol + 0;
                    crow = crow -1;
                    %if (crow == 0 || crow == 9 || ccol ==0 || ccol == 9) , break; end;        
                    if (crow == 0) , break; end;        
                    %lrow = crow; lcol = ccol;
                    lrow = crow;
                    modBoard (crow, ccol) = color;   
                    switch board(crow,ccol)
                        case 0
                        valid = 1;                            
                        break;    % breaks the WHILE, not the switch!        
                        case color
                        break;            
                        otherwise    
                        revs = revs + 1;
                    end
                end
                % ################### HAVE TRAP ######################
                % save modified board and set disk (if present)
                if (valid)
                    % first check whether this disk is already found (this implies this
                    % disk causes a side effect, which already has been listed as a
                    % possible move). If so, combine the two moves to
                    % one big move with side effect.
                    if isempty(disksNew) 
                        relatedBoardIDX=[]; 
                    else 
                        relatedBoardIDX = find(disksNew(1,:) == lrow & disksNew(2,:) == lcol, 1);
                    end
                    if (isempty(relatedBoardIDX))
                        % normal move
                        disksNew = cat(2,disksNew, [lrow;lcol]);
                        possibleBoards = cat(3, possibleBoards, modBoard);         
                        numDisksRev = cat(2,numDisksRev,revs);
                    else
                        % one with side effects
                        % warning(['disk [' num2str(disksNew(1,1)) ';' num2str(disksNew(2,1)) '] already found (duplicate). Combining both boards.']);   % DEBUG MESSAGE - REMOVE!
                        possibleBoards(:,:,relatedBoardIDX) = mine_win(possibleBoards(:,:,relatedBoardIDX), modBoard);                                
                        numDisksRev(relatedBoardIDX) = numDisksRev(relatedBoardIDX) + revs;
                    end        
                end  
            end

            % vertically down (INcreasing row coord)
            if (~isempty(find(diff_opponent(2,idx,z)==0 & diff_opponent(1,idx,z)==1,1)))                
                % ################### GET A TRAP #####################
                %vecdir = [1;0];                
                modBoard = board;  % the board resulting from a trap    
                valid = 0;        
                revs = 0; 
                crow = mine_coord_haveNeigh(1,z); ccol = mine_coord_haveNeigh(2,z);
                lcol = ccol;
                while true               
                    %ccol = ccol + 0;
                    crow = crow + 1;
                    %if (crow == 0 || crow == 9 || ccol ==0 || ccol == 9) , break; end;        
                    if (crow == 9) , break; end;        
                    %lrow = crow; lcol = ccol;
                    lrow = crow;
                    modBoard (crow, ccol) = color;   
                    switch board(crow,ccol)
                        case 0
                        valid = 1;                            
                        break;    % breaks the WHILE, not the switch!        
                        case color
                        break;            
                        otherwise    
                        revs = revs + 1;
                    end
                end
                % ################### HAVE TRAP ######################
                % save modified board and set disk (if present)
                if (valid)
                    % first check whether this disk is already found (this implies this
                    % disk causes a side effect, which already has been listed as a
                    % possible move). If so, combine the two moves to
                    % one big move with side effect.
                    if isempty(disksNew) 
                        relatedBoardIDX=[]; 
                    else 
                        relatedBoardIDX = find(disksNew(1,:) == lrow & disksNew(2,:) == lcol, 1);
                    end
                    if (isempty(relatedBoardIDX))
                        % normal move
                        disksNew = cat(2,disksNew, [lrow;lcol]);
                        possibleBoards = cat(3, possibleBoards, modBoard);         
                        numDisksRev = cat(2,numDisksRev,revs);
                    else
                        % one with side effects
                        % warning(['disk [' num2str(disksNew(1,1)) ';' num2str(disksNew(2,1)) '] already found (duplicate). Combining both boards.']);   % DEBUG MESSAGE - REMOVE!
                        possibleBoards(:,:,relatedBoardIDX) = mine_win(possibleBoards(:,:,relatedBoardIDX), modBoard);                                
                        numDisksRev(relatedBoardIDX) = numDisksRev(relatedBoardIDX) + revs;
                    end        
                end
            end            
        end
    
        diagIDX = find(abs(diff_opponent(2,:,z))==abs(diff_opponent(1,:,z)));
        if (~isempty(diagIDX)) % if there are ANY diagonals 
            if (~isempty(find(dist_opponent(1,diagIDX,z) < 1.5,1))) % if there are ANY diagonally ADJACENT opponents
                
                % check diagonal up-left (DEcreasing row coord and DEcreasing col coord)
                if (~isempty(find(diff_opponent(1,diagIDX,z)==-1 & diff_opponent(2,diagIDX,z)==-1,1)))                
                    % ################### GET A TRAP #####################
                    %vecdir = [-1;-1];                
                    modBoard = board;  % the board resulting from a trap    
                    valid = 0;        
                    revs = 0; 
                    crow = mine_coord_haveNeigh(1,z); ccol = mine_coord_haveNeigh(2,z);
                    while true               
                        ccol = ccol -1;
                        crow = crow -1;
                        if (crow == 0 || ccol ==0) , break; end;        
                        lrow = crow; lcol = ccol;
                        modBoard (crow, ccol) = color;   
                        switch board(crow,ccol)
                            case 0
                            valid = 1;                            
                            break;    % breaks the WHILE, not the switch!        
                            case color
                            break;            
                            otherwise    
                            revs = revs + 1;
                        end
                    end
                    % ################### HAVE TRAP ######################
                    % save modified board and set disk (if present)
                    if (valid)
                        % first check whether this disk is already found (this implies this
                        % disk causes a side effect, which already has been listed as a
                        % possible move). If so, combine the two moves to
                        % one big move with side effect.
                        if isempty(disksNew) 
                            relatedBoardIDX=[]; 
                        else 
                            relatedBoardIDX = find(disksNew(1,:) == lrow & disksNew(2,:) == lcol, 1);
                        end
                        if (isempty(relatedBoardIDX))
                            % normal move
                            disksNew = cat(2,disksNew, [lrow;lcol]);
                            possibleBoards = cat(3, possibleBoards, modBoard);         
                            numDisksRev = cat(2,numDisksRev,revs);
                        else
                            % one with side effects
                            % warning(['disk [' num2str(disksNew(1,1)) ';' num2str(disksNew(2,1)) '] already found (duplicate). Combining both boards.']);   % DEBUG MESSAGE - REMOVE!
                            possibleBoards(:,:,relatedBoardIDX) = mine_win(possibleBoards(:,:,relatedBoardIDX), modBoard);                                
                            numDisksRev(relatedBoardIDX) = numDisksRev(relatedBoardIDX) + revs;
                        end        
                    end
                end
                
                % check diagonal up-right (DEcreasing row coord and INcreasing col coord)
                if (~isempty(find(diff_opponent(1,diagIDX,z)==-1 & diff_opponent(2,diagIDX,z)==1,1)))                
                    % ################### GET A TRAP #####################
                    %vecdir = [-1;1];                
                    modBoard = board;  % the board resulting from a trap    
                    valid = 0;        
                    revs = 0; 
                    crow = mine_coord_haveNeigh(1,z); ccol = mine_coord_haveNeigh(2,z);
                    while true               
                        ccol = ccol + 1;
                        crow = crow - 1;
                        if (crow == 0 || ccol == 9) , break; end;        
                        lrow = crow; lcol = ccol;
                        modBoard (crow, ccol) = color;   
                        switch board(crow,ccol)
                            case 0
                            valid = 1;                            
                            break;    % breaks the WHILE, not the switch!        
                            case color
                            break;            
                            otherwise    
                            revs = revs + 1;
                        end
                    end
                    % ################### HAVE TRAP ######################
                    % save modified board and set disk (if present)
                    if (valid)
                        % first check whether this disk is already found (this implies this
                        % disk causes a side effect, which already has been listed as a
                        % possible move). If so, combine the two moves to
                        % one big move with side effect.
                        if isempty(disksNew) 
                            relatedBoardIDX=[]; 
                        else 
                            relatedBoardIDX = find(disksNew(1,:) == lrow & disksNew(2,:) == lcol, 1);
                        end
                        if (isempty(relatedBoardIDX))
                            % normal move
                            disksNew = cat(2,disksNew, [lrow;lcol]);
                            possibleBoards = cat(3, possibleBoards, modBoard);         
                            numDisksRev = cat(2,numDisksRev,revs);
                        else
                            % one with side effects
                            % warning(['disk [' num2str(disksNew(1,1)) ';' num2str(disksNew(2,1)) '] already found (duplicate). Combining both boards.']);   % DEBUG MESSAGE - REMOVE!
                            possibleBoards(:,:,relatedBoardIDX) = mine_win(possibleBoards(:,:,relatedBoardIDX), modBoard);                                
                            numDisksRev(relatedBoardIDX) = numDisksRev(relatedBoardIDX) + revs;
                        end        
                    end
                end
                
                % check diagonal down-right (INcreasing row coord and INcreasing col coord)
                if (~isempty(find(diff_opponent(1,diagIDX,z)==1 & diff_opponent(2,diagIDX,z)==1,1)))                
                    % ################### GET A TRAP #####################
                    %vecdir = [1;1];                
                    modBoard = board;  % the board resulting from a trap    
                    valid = 0;        
                    revs = 0; 
                    crow = mine_coord_haveNeigh(1,z); ccol = mine_coord_haveNeigh(2,z);
                    while true               
                        ccol = ccol + 1;
                        crow = crow + 1;
                        if (crow == 9 || ccol == 9) , break; end;        
                        lrow = crow; lcol = ccol;
                        modBoard (crow, ccol) = color;   
                        switch board(crow,ccol)
                            case 0
                            valid = 1;                            
                            break;    % breaks the WHILE, not the switch!        
                            case color
                            break;            
                            otherwise    
                            revs = revs + 1;
                        end
                    end
                    % ################### HAVE TRAP ######################
                    % save modified board and set disk (if present)
                    if (valid)
                        % first check whether this disk is already found (this implies this
                        % disk causes a side effect, which already has been listed as a
                        % possible move). If so, combine the two moves to
                        % one big move with side effect.
                        if isempty(disksNew) 
                            relatedBoardIDX=[]; 
                        else 
                            relatedBoardIDX = find(disksNew(1,:) == lrow & disksNew(2,:) == lcol, 1);
                        end
                        if (isempty(relatedBoardIDX))
                            % normal move
                            disksNew = cat(2,disksNew, [lrow;lcol]);
                            possibleBoards = cat(3, possibleBoards, modBoard);         
                            numDisksRev = cat(2,numDisksRev,revs);
                        else
                            % one with side effects
                            % warning(['disk [' num2str(disksNew(1,1)) ';' num2str(disksNew(2,1)) '] already found (duplicate). Combining both boards.']);   % DEBUG MESSAGE - REMOVE!
                            possibleBoards(:,:,relatedBoardIDX) = mine_win(possibleBoards(:,:,relatedBoardIDX), modBoard);                                
                            numDisksRev(relatedBoardIDX) = numDisksRev(relatedBoardIDX) + revs;
                        end        
                    end
                end
                
                % check diagonal down-left (INcreasing row coord and DEcreasing col coord)
                if (~isempty(find(diff_opponent(1,diagIDX,z)==1 & diff_opponent(2,diagIDX,z)==-1 ,1)))                
                    % ################### GET A TRAP #####################
                    %vecdir = [1;-1];                
                    modBoard = board;  % the board resulting from a trap    
                    valid = 0;        
                    revs = 0; 
                    crow = mine_coord_haveNeigh(1,z); ccol = mine_coord_haveNeigh(2,z);
                    while true               
                        ccol = ccol - 1;
                        crow = crow + 1;
                        if (crow == 9 || ccol ==0) , break; end;        
                        lrow = crow; lcol = ccol;
                        modBoard (crow, ccol) = color;   
                        switch board(crow,ccol)
                            case 0
                            valid = 1;                            
                            break;    % breaks the WHILE, not the switch!        
                            case color
                            break;            
                            otherwise    
                            revs = revs + 1;
                        end
                    end
                    % ################### HAVE TRAP ######################
                    % save modified board and set disk (if present)
                    if (valid)
                        % first check whether this disk is already found (this implies this
                        % disk causes a side effect, which already has been listed as a
                        % possible move). If so, combine the two moves to
                        % one big move with side effect.
                        if isempty(disksNew) 
                            relatedBoardIDX=[]; 
                        else 
                            relatedBoardIDX = find(disksNew(1,:) == lrow & disksNew(2,:) == lcol, 1);
                        end
                        if (isempty(relatedBoardIDX))
                            % normal move
                            disksNew = cat(2,disksNew, [lrow;lcol]);
                            possibleBoards = cat(3, possibleBoards, modBoard);         
                            numDisksRev = cat(2,numDisksRev,revs);
                        else
                            % one with side effects
                            % warning(['disk [' num2str(disksNew(1,1)) ';' num2str(disksNew(2,1)) '] already found (duplicate). Combining both boards.']);   % DEBUG MESSAGE - REMOVE!
                            possibleBoards(:,:,relatedBoardIDX) = mine_win(possibleBoards(:,:,relatedBoardIDX), modBoard);                                
                            numDisksRev(relatedBoardIDX) = numDisksRev(relatedBoardIDX) + revs;
                        end        
                    end
                end
                
            end %adjacent
        end %hasDiag
        %diag = diff_opponent(:,find(abs(diff_opponent(2,:,z))==abs(diff_opponent(1,:,z))),z);
                
    end % for

%% DO NOT USE: index exceeds matrix dimensions. buggy somehow. not tracked down, yet.
%     % ### Check if the dictionary did pass any moves to avoid (bad moves)
%     if ~isempty(badDisks)
%         numBadMoves = size(badDisks,2);
%         disp([mfilename ': have ' num2str(numBadMoves) ' bad moves from dictionary to avoid.']);
%         
%         % remove the bad moves from the list, but avoid emptying the list completley (forced bad moves must be played).
%         % if all the moves are bad, then don't remove anything, since the
%         % tradeoff must be made by the evaluation algorithm.
%         if (numBadMoves < numel(numDisksRev))
%             remBoards = 0;
%             for k = 1:numBadMoves   % remove them one after the other from the list
%                 % @todo optimze! On the other hand this part of the code
%                 % isn't very frequent, presumably.
%                 for listIDX = 1:numel(numDisksRev)
%                     if (isequal(badDisks(:,k),disksNew(:,listIDX))) % match! -> remove
%                         possibleBoards(:,:,listIDX) = [];      % remove possibleBoard plane #k
%                         numDisksRev(listIDX) = [];             % remove numDisksRev #k
%                         disksNew(:,listIDX) = [];              % remove disksNew column #k
%                         remBoards = remBoards + 1;
%                         listIDX = listIDX - 1; 
%                     end                
%                 end
%             end
%             disp([filename ': Removed ' num2str(remBoards) ' known bad moves from possibilities.']);
%         else
%             disp([mfilename ': All possible moves are bad, nothing I can do. Returning them all.']);
%         end
%     end
    
     dict_flag = use_dictionary; % ADD: gerri


end % function    