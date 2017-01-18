function [ alpha, brd ] = PF_alphabeta( board, color, depth, alpha, beta)
%PF_ALPHABETA alpha-beta version of the minimax algorithm
%   Input arguments:
%   board
%   depth - of search. Depth=0 just evaluates the board.
%   alpha -
%   beta - values for pruning. Start with [-Inf, Inf].
    
%   Output arguments:
%   value

if (depth<=0)
	%% if leaf node, just calculate value
    if (isstruct(board))
        board=board.pos;
    end
    alpha = PF_evaluateMove(board, color);
else
    if (~isfield(board,'sub'))
        %% no subtree available
        if (isstruct(board))
            board=board.pos;
        end
        legal = PF_validMoves(board, -color);

        if ~isempty(legal)
            leglen=length(legal);
            values = zeros(1,leglen);
    
            for l=1:leglen;
                brd_new = PF_makeMove(board,-color,legal(l));
                [values(l), brd.sub(l)] = PF_alphabeta( brd_new, -color, depth-1, -beta, -alpha);
                if (values(l)>alpha)
                    alpha=values(l);
                end
                %disp ([mfilename ': dp=', num2str(depth-1), sprintf('\t'), 'it=', num2str(l), '/', num2str(leglen),  sprintf('\t'), 'alpha=', num2str(alpha), sprintf('\t'), 'beta=', num2str(beta)]);
                if (values(l)>=beta);
                    break
                end
            end
            alpha=-alpha;
            %disp ([mfilename ': Values at depth ' num2str(depth-1) ':']);
            %disp (values);
    
        else
            [val, brd.sub] = PF_alphabeta( board, -color, depth-1, -beta, -alpha);
            if (val>alpha)
                alpha=-val;
            end
            %disp (['Cannot move at depth ' num2str(depth-1) ', value=' num2str(val)]);
        end
    else
        %% we have a subtree already
        leglen=length(board.sub);
        values = zeros(1,leglen);
        for l=1:leglen
            [values(l), brd.sub(l)] = PF_alphabeta( board.sub(l), -color, depth-1, -beta, -alpha);
            if (values(l)>alpha)
                alpha=values(l);
            end
            %disp ([mfilename ': dp=', num2str(depth-1), sprintf('\t'), 'it=', num2str(l), '/', num2str(leglen),  sprintf('\t'), 'alpha=', num2str(alpha), sprintf('\t'), 'beta=', num2str(beta)]);
            if (values(l)>=beta);
                break
            end
        end
        alpha=-alpha;
        board=board.pos;
        %disp ([mfilename ': Values at depth ' num2str(depth-1) ':']);
        %disp (values);
    end
end

brd.val = alpha;
brd.pos = board;
    
end

