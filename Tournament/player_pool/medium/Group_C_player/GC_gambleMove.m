% @brief Given a list of dictionary entries, this function randomly selects one of
% these moves, whereas moves with higher score are drawn more often.
% 
% @author Martin Becker
% @date 2011-Jan-15
% 
% @param moveList a list of (good) moves. The structure must be:
%      moveList{k,1} = numPlayersBlack: an integer value indicating how
%                                       often a black player made this move
%      moveList{k,2} = numPlayersWhite: an integer value indicating how
%                                       often a white player made this move
%      moveList{k,3} = score_fin_black: an integer number yielding the
%                                       points of the black player at the end of the game, whereas the game
%                                       was continued "perfectly" in the sense of maximal search depth
%                                       (given in the WTHOR file) until the end.
%      moveList{k,4} = seq:             Finally, this is the alphanumeric
%                                       string describing the move sequence.
% @retval i_sel a positive number [1...size(moveList,2)] indicating selected
%     row of moveList.
function [ i_sel ] = GC_gambleMove( moveList )
    
    % SELECTION. Plan: make cumsum over points. Then randomize a value
    % between 0 and max value. Then search the element into which this
    % value falls. The result should be a score-dependant probability for
    % each move.
     
    points = cell2mat(moveList(:,3));
    points_weighted = (points - repmat(31,size(moveList,1),1)).^2; % should work better then: subtract 31 points. That leads to more significant weighting of the good moves.
    cum_points = cumsum(points_weighted);
    
    % gambling here....
    luckyPoints = rand()*cum_points(end);

    % now check which one was selected.
    i_sel = find(cum_points >= luckyPoints,1); % finds the NEXT item of the selected one.
    