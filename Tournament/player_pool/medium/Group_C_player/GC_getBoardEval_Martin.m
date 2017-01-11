% @brief Heuristic evualuation function. Judges for a given board, whereas I am
% coded with 'color', if the situation is good for me. Here it prefers
%  1) occupying the corners and 
%  2) having a maximal number of disks and
%  3) maximizing mobility
%  4) 
% 
% @author Martin Becker
% @date 2011-Jan-24
% 
% @param board the playing board described by an 8-by-8 matrix.
% @param color - positions in 'board' where the value equals 'color' are
%     assumed
%     to be my disks. Elements with zero are assumed to be free, whereas
%     others are all opponents.
% @param roundNo round number - used to change strategy over time
% @retval eval a scalar double-type value indicating how 'good' the given
%     constellation is for me. Higher values are better.
function [eval] = GC_getBoardEval_Martin(board, color, roundNo)      

persistent good_edge;
persistent bad_edge;
persistent fantastic_edge;

% Corners
% - Corner positions, once played, remain immune to flipping for the rest of the game 
% - player could use a piece in a corner of the board to anchor groups of pieces (starting with the adjacent edges) permanently. 
% - capturing a corner often proves an effective strategy when the opportunity arises
% - More generally, a piece is stable when, along all four axes (horizontal, vertical, and each diagonal), it is on a boundary, in a filled row, or next to a stable piece of the same color. 
% - Grabbing a corner prematurely may be a mistake, however, if in doing so the player leaves "holes" along the edge. 
% - These holes can be filled by the opposing player and could result in capture of some or most of the pieces along that edge. This renders occupying the corner largely useless.

% Mobility
% - An opponent playing with reasonable strategy will not so easily relinquish the corner or any other good moves
% - to achieve these good moves, a player must force his or her opponent to play moves that relinquish those good moves
% - One of the ways to achieve this involves reducing the number of moves available to the player's opponent.
% - Ideally, this will eventually force the opponent to make an undesirable move.

% Edges
% - edge pieces can anchor flips that influence moves to all regions of the board
% - if played poorly, this can poison later moves by causing players to flip too many pieces and open up many moves for the opponent
% - playing on edges where an opponent cannot easily respond drastically reduces possible moves for that opponent 
% - square immediately diagonally adjacent to the corner, when played in the early or middle game, typically guarantees the loss of that corner. 
% - such a corner sacrifice is sometimes played for some strategic purpose (like retaining mobility)
% - Playing to the edge squares adjacent to the corner can also be dangerous

% Parity
% - one of the most important parts of the strategy
% - is about getting the last move in every empty region in the end-game and thereby increasing the number of stable discs.
% - this concept led to a change in the perception of the game, as it led to distinct strategies for playing black and white
% - it forced black to play more aggressive moves and gave white the opportunity to stay calm and focus on keeping the parity
% - as a result the opening books and mid-game were focused on black being the "attacker" and white being the "defender".
% - concept of parity also controls how edge positions are played and how edges interact.

% Endgame
% - sweeping, 
% - gaining access
% - details of move-order 
% - Actual counting of discs in the very final stages is often critical

%% DISCRIMINATE BETWEEN ME AND OPPONENT
mine = (board == color);
opp  = (board ==-color);

%% COMPOUND EVALUATION - dependant on current round number
    if (roundNo < 10)
        % BEGINNING (ply 1 to 9)
        % - rely on dictionary for the first say 5 moves
        % - avoid corners
        % - maximize mobility
        % - maximize disks

        % weights for the different aspects (sum should equal 1!)
        coeff_corner      =  .4;
        coeff_disk_excess =  .4;
        coeff_mobility    =  .2;
        coeff_parity      =  .0;
        coeff_edges       =  .0;

    elseif (roundNo  < 20)
        % MIDGAME (ply 10 to 19)
        % - keep up mobility
        % - go for corners, but do not force it
        % - use occupied corners to place stable disks
        % - build edges along corners, but avoid odd gaps, try to make even
        
        % weights for the different aspects (sum should equal 1!)
        coeff_corner      =  .5;    % go for corners.
        coeff_disk_excess =  .2;    % to some amount
        coeff_mobility    =  .1;    % take back
        coeff_parity      =  .0;    % too early for parity.
        coeff_edges       =  .2;    % somehow does't work as expected.
    else
        % ENDGAME (ply 20+)
        % - go for corners hardly
        % - use occupied corners to place stable disks
        % - parity: try to be the last to place a disk in empty regions
        coeff_corner      =  .6;
        coeff_disk_excess =  .1;    % this is too late
        coeff_mobility    =  .0;    % force the opponent 
        coeff_parity      =  .3;    % important!
        coeff_edges       =  .0;    % should be occupied by now anyway

    end

if coeff_corner ~= 0
%%  CORNERS: AVOID OPPONENT OCCUPYING CORNERS. ACCUMULATE AT CORNERS IF MY
%%  DISKS ARE ALREADY THERE.

    % neutral - assumes corners are empty
    M = [15, -5,  1,  0,  0,  1, -5, 15; ...
         -5,-10,  1,  0,  0,  1,-10, -5; ...
          1,  1,  1,  0,  0,  1,  1,  1; ...
          0,  0,  0,  0,  0,  0,  0,  0; ... 
          0,  0,  0,  0,  0,  0,  0,  0; ...
          1,  1,  1,  0,  0,  1,  1,  1; ...
         -5,-10,  1,  0,  0,  1,-10, -5; ... 
         15, -5,  1,  0,  0,  1, -5, 15];

    % modify the scoring if the corners are actually MINE already. This
    % helps to set stable disks around my corners.
    if M(1,1)==color
        M(2,1)= 5;
        M(1,2)= 5;        
    end
    if M(8,1)==color
        M(8,2)= 5;
        M(7,1)= 5;        
    end
    if M(1,8)==color
        M(1,7)= 5;
        M(2,8)= 5;        
    end
    if M(8,8)==color
        M(7,8)= 5;
        M(8,7)= 5;        
    end
    if (M(1,3)==color) && (M(3,1)==color)
        M(2,2) = 5; % B2
    end
    if (M(6,1)==color) && (M(8,3)==color)
        M(7,2) = 5; % B7 
    end
    if (M(1,6)==color) && (M(3,8)==color)
        M(2,7) = 5; % G2
    end
    if (M(6,8)==color) && (M(8,6)==color)
        M(7,7) = 5; % G7
    end
    
    score_corner = (M.*mine) - (M.*opp) ;       
    score_corner = sum(score_corner(:));
    
    % extra score for full corners
    M = [ 1, 1, 1, 0, 0, 0, 0, 0; ...
          1, 1, 0, 0, 0, 0, 0, 0; ...
          1, 0, 0, 0, 0, 0, 0, 0; ...
          0, 0, 0, 0, 0, 0, 0, 0; ... 
          0, 0, 0, 0, 0, 0, 0, 0; ...
          0, 0, 0, 0, 0, 0, 0, 0; ...
          0, 0, 0, 0, 0, 0, 0, 0; ... 
          0, 0, 0, 0, 0, 0, 0, 0];      
      for k=1:4
            if (isequal(mine.*M, M))
                score_corner = score_corner + 10;
            end
            if (isequal(opp.*M, M))
                score_corner = score_corner - 10;
            end
            M = rot90(M);
      end
else
    score_corner = 0;
end    
     
if coeff_edges ~= 0
%% EDGES - judges on accessing the edges if either corners are empty or if
%% they are mine.
    
    % use persistents so speed up. No need to re-generate the matrices
    % below every time.
    
    score_edges = 0;
    
    if (isempty(good_edge)) 
        good_edge(:,1) = [0;0;color;0;0;color;0;0];
        good_edge(:,2) = [0;color;0;0;0;0;color;0];
        good_edge(:,3) = [color;color;0;0;0;0;color;color];
    end
    if (isempty(fantastic_edge)) 
        fantastic_edge(:,1) = [color;color;color;color;color;color;color;color];
        fantastic_edge(:,2) = [color;color;color;    0;    0;color;color;color];
    end
    if (isempty(bad_edge))
        bad_edge(:,1)  = [0;0;color;0;color;0;0;0]; % odd gap
        bad_edge(:,2)  = [0;0;0;color;0;color;0;0]; % odd gap
        bad_edge(:,3)  = [0;color;0;color;0;0;0;0]; % odd gap
        bad_edge(:,4)  = [0;0;0;0;color;0;color;0]; % odd gap
        bad_edge(:,5)  = [0;0;color;0;0;0;color;0]; % odd gap
        bad_edge(:,6)  = [0;color;0;0;0;color;0;0]; % odd gap
    end
    
    % all 4 edges
    currentEdges = [ board(:,1) board(:,8) board(1,:)' board(8,:)'];    % must be column vectors. each colum is an edge
    
    for thisEdge = 1:4        
        for g = 1:size(fantastic_edge,2)
            if (isequal(fantastic_edge, -currentEdges(:,thisEdge))), score_edges = score_edges - 5; end % opponent is lucky
            if (isequal(fantastic_edge,  currentEdges(:,thisEdge))), score_edges = score_edges + 5; end % I am lucky
        end
    end
    
    %% NOW ACCOUNT FOR EVEN AND ODD GAPS IN THE CORNERS
    % Sifting for the corner disks, if these are MINE. Otherwise this would
    % totally prevent the even/odd rules to be used. However, if the corner is occupied by an opponent, don't score the edge at all. This situation then is
    % just indifferent.
    currentEdges(1,(currentEdges(1,:)==color))=0;
    currentEdges(8,(currentEdges(1,:)==color))=0;
   
    % now score good and bad edges
    for thisEdge = 1:4 
       
        for g = 1:size(good_edge,2)
            if (isequal(good_edge, currentEdges(:,thisEdge))), score_edges = score_edges + 1; end
            if (isequal(good_edge, -currentEdges(:,thisEdge))), score_edges = score_edges - 1; end % when opp is there it's good
        end
        for b = 1:size(bad_edge,2)
            if (isequal(bad_edge, currentEdges(:,thisEdge))), score_edges = score_edges - 1; end
            if (isequal(bad_edge, -currentEdges(:,thisEdge))), score_edges = score_edges + 1; end   % when opp is there it's good
        end
    end
else 
    score_edges = 0;
end

if ((coeff_mobility ~= 0) || (coeff_disk_excess ~= 0))    % need that result of getValidPositions for disk excess as well
%% MOBILITY
    % it is no big problem to call getValidPositions for each board I have
    % to score. Scoring is actually only done at the leafs of the search
    % tree, which is why This should't be too much of a slowdown.
    [ possibleBoards, disksNew, numDisksRev ] = getValidPositions(board, -color, 3, ''); % fake sequence and round number to get all options. I don't have the game sequence anyway.
    if (~isempty(numDisksRev))
        numPossibilities = numel(numDisksRev);
    else
        numPossibilities = 0;
    end
    
    % actually the next ply is opponent, so the mobility should be kept to
    % a minimum.
    score_mobility = -numPossibilities;
else
    score_mobility = 0;
end
   
if coeff_disk_excess ~= 0.
%% NUMBER OF DISKS I HAVE MORE THAN OPPONENT. ALSO ACCOUNT FOR NEXT ROUND'S MAXIMUM (WHICH MUST BE KEPT MINIMAL, AS THIS REFLECTS OPPONENT'S GAIN).    
    score_disk_excess = sum(mine(:)) - sum(opp(:));      
	if (~isempty(numDisksRev))
		score_disk_excess = score_disk_excess + numel(numDisksRev);
	end
else
    score_disk_excess = 0;
end
   
if coeff_parity ~= 0
%% PARITY
score_parity = 0;

% get all free areas
emptyAreas = (board == 0);

% get connected components
[L,num]=bwlabel(emptyAreas, 4);
for k = 1:num
    that = (L==k);
    numFree = sum(sum(that));
    if (rem(numFree,2))
        % areas with odd number of free fields are bad
        score_parity = score_parity - 1;
        %disp(['Parity: found an odd free area -> -1']);
    else
        % areas with even number of feee fields are good
        score_parity = score_parity + 1;
        %disp(['Parity: found an even free area -> +1']);
    end
end
else
    score_parity = 0;
end

           
% scoring total    
eval = coeff_corner*score_corner + coeff_disk_excess*score_disk_excess + coeff_mobility*score_mobility + coeff_parity*score_parity + coeff_edges*score_edges;
end