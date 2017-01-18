function score = PWND_evaluateBoard(b, color)
% This function evaluates the actual board, e.g. considering the recent
% effects of the recent move. The evaluation is based on several aspects
% multiplied by respective weights.

if sum(sum(b~=0)) < 64
%% Basic evaluation of the fields on the actual board (now: modification of corners possible)
weight_board = 100;
value_board = PWND_valueBoard(b,color) - PWND_valueBoard(b,-color); % All weights of our fields - all weights of the opponents fields

%% Number of possessed fields
weight_number = 15*(sum(sum(b~=0))-30); % The weight gets bigger within the progress of the game
value_number = sum(sum(b==color))-sum(sum(b==-color));  % Amount of our fields -  amount of the opponents fields

%% Stable Fields
weight_stable = 100;
value_stable = PWND_stableDiscs(b, color) - PWND_stableDiscs(b, -color);    % Our stable fields - the opponents stable fields

%% Mobility
weight_emptyneighbors = 75;
value_emptyneighbors = size(PWND_frontierDisks(b,color), 1) - size(PWND_frontierDisks(b,-color), 1); % Our mobility - the opponents mobility

%% Compute the overall score as weighted sum of the above mentioned criteria
score = weight_board*value_board + weight_number*value_number + ...
    weight_stable*value_stable + weight_emptyneighbors*value_emptyneighbors;

else  
    %% End of game: Evaluate for win or loose
    score = sum(sum(b==color))-sum(sum(b==-color));

end
