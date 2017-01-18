function [ brd ] = PF_negamax_sort( board, color, depth, perfectplay, dryrun)
%function [ value, brd ] = PF_negamax( board, color, depth )
%NEGAMAX negamax version of the minimax algorithm
%   Input arguments:
%   board
%   depth - of search. Depth=0 just evaluates the board.
%   old_delta_stables
%   old_delta_mob
    
%   Output arguments:
%   value

if (depth > 0)
    %% normal node
    legal = PF_validMoves(board, -color);

    if ~isempty(legal)
        for l=1:length(legal);
            brd_new = PF_makeMove(board,-color,legal(l));
            brd.sub(l) = PF_negamax_sort( brd_new, -color, depth-1, perfectplay, dryrun);
        end
        
        [unused, order] = sort([brd.sub(:).val],'descend');
        brd.sub = brd.sub(order); 

        %disp ([mfilename ': Values at depth ' num2str(depth-1) ':']);
        %disp ([brd.sub(:).val);
        
        brd.val = -brd.sub(1).val;

    else
        if (perfectplay)
            % current player has to pass, increase search depth
            % but only if opponent can move, otherwise endless loop
            if (isempty(PF_validMoves(board, color)))
                brd.sub = PF_negamax_sort( board, -color, depth-1, perfectplay, dryrun);
            else
                brd.sub = PF_negamax_sort( board, -color, depth, perfectplay, dryrun);
            end
        else
            brd.sub = PF_negamax_sort( board, -color, depth-1, perfectplay, dryrun);
        end
        brd.val = -brd.sub.val;
        %disp (['Cannot move at depth ' num2str(depth-1)]);
    end
    
elseif (perfectplay == 0)
    %% leaf node, midgame
    brd.val = PF_evaluateMove(board, color);
    
elseif (sum(board(:)==0)==0)
    %% leaf node, endgame
    brd.val = color*sum(board(:));

else
    %% leaf node, endgame, free fields on board
    if (isempty(PF_validMoves(board, color)) && isempty(PF_validMoves(board, -color)))
        % nobody can move, game ends with empty fields
        brd.val = color*sum(board(:));
    else
        % deeper search possible !!! What are we doing here?
        if (dryrun~=1)
            disp('Something went terribly wrong!!! Evaluating value for non-leaf node!');
        end
        brd.val = color*sum(board(:));
    end
  
end
       
brd.pos = board;
    
end

