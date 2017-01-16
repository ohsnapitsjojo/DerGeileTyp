function [b_valid, moves] = DGRT_legalMoves(b, player)
% This function returns all valid moves, including the whole board after
% execution of legal move

% define board indices
mapIdx = 1:64;
% define opponent
opponent = -player;

%% get free spots near opponent
moves = mapIdx((conv2(double(b==opponent), ones(3), 'same')~= 0) & (b==0));

%% check if moves flip stones
% number of move candidates
moveNum = length(moves);
% init flags
flag_validMove = false(1,moveNum);
% init new boards
b_valid = repmat(b,1,1,moveNum);

for moveIdx = 1:moveNum
    
    % set current move
    move = moves(moveIdx);
    
    % column number
    x = ceil(move/8);
    % row number
    y = mod(move-1,8)+1;

    % check all directions
    for direction = 1:8

        switch direction
            case 1 % south
                nextX = 0;
                nextY = 1;
            case 2 % east
                nextX = 1;
                nextY = 0;
            case 3 % north
                nextX = 0;
                nextY = -1;
            case 4 % west
                nextX = -1;
                nextY = 0;
            case 5 % south east
                nextX = 1;
                nextY = 1;
            case 6 % north east
                nextX = 1;
                nextY = -1;
            case 7 % north west
                nextX = -1;
                nextY = -1;
            case 8 % south west
                nextX = -1;
                nextY = 1;
        end

        % set current position to stone next to move
        currX = x + nextX;
        currY = y + nextY;
        
        % init flags for flipped stones
        flippedStones = 0;
        flag_flipDirection = false;

        while currX >= 1 && currY >= 1 && currX <= 8 && currY <= 8 % current position must be within board
            % abort search for this direction if no furhter stone is found
            if b(currY,currX)==0
                break;
            end
            % abort search for this direction if player's stone found
            if b(currY,currX)==player
                if flippedStones>0
                    flag_flipDirection = true;
                    flag_validMove(moveIdx) = true;
                end
                break;
            end
            if b(currY,currX)==opponent
                flippedStones = flippedStones+1;
            end
            currX = currX + nextX;
            currY = currY + nextY;
        end

        % flip stones
        if flag_flipDirection
            while currX~=x || currY~=y
                currX = currX - nextX;
                currY = currY - nextY;
                b_valid(currY,currX,moveIdx) = player;
            end          
        end

    end

end

% only return moves that flip stones
b_valid = b_valid(:,:,flag_validMove);
moves = moves(flag_validMove);

end