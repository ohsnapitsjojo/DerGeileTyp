function new_board = team6(b,color,time_left)

addpath(['players' filesep mfilename]);

global number_of_turns
number_of_turns = sum(sum(b ~= 0))-4;

try
    %% Calculate search depth
    depth = DetermineSearchDepth(b, time_left);
    
%     % just apply negamax without database
    disp([mfilename ': The current search depth is ' num2str(depth)]);
    [test1, new_board] = NegamaxPruning(b, color, -inf, +inf, depth);
%     % delete after the lower "database check" is implemented
    
%    % <- should be implemented
%         %% Apply of negamax algorithm
%         max_nr = 20;
%        number_of_stones = sum(sum(b ~= 0))-3;
%         if number_of_stones < max_nr % Check for database move
%             [new_board, found] =DatabaseSearch(b, color,number_of_stones);
%             if found == false
%                 disp([mfilename ': No move was found in database']);
%                 disp([mfilename ': The current search depth is ' num2str(depth)]);
%                 new_board = NegamaxPruning(b, color, -inf, +inf, depth);
%             end
%         else
%             disp([mfilename ': The current search depth is ' num2str(depth)]);
%             new_board = NegamaxPruning(b, color, -inf, +inf, depth);
%         end
    
catch error_1 % weak error - we are now using search dept 1
    disp([mfilename ': Error: ' error_1.message]);
    disp([mfilename ': An error occure, we are now using search depth 1']);
    try
        allowed_position = FindAllowedPositions(b, color);
        nummer_of_allowed_positions = zeros(size(allowed_position,3),1);
        for k = 1:size(allowed_position,3)
            nummer_of_allowed_positions(k) = EvaluateBoard(allowed_position(:,:,k), color);
        end
        [test2, index]= max(nummer_of_allowed_positions);
        new_board = allowed_position(:,:,index);
        %         allowed_positions = FindAllowedPositions(b, color);
        %         index = EvaluateBoard(b, color);
        %         new_board = allowed_positions(:,:,index);
    catch error_2 % strong error - we are now doing a random move
        disp([mfilename ': Error: ' error_2.message]);
        disp([mfilename ': An error occure, we are now doing random move']);
        try
            allowed_positions = FindAllowedPositions(b, color);
            new_board = allowed_positions(:,:,ceil(rand*size(allowed_positions,3)));
        catch error_3 % worst error - our algorithm failed
            disp([mfilename ': Error: ' error_3.message]);
            disp('An error occure. The alogrithm failed!');
        end
    end
end