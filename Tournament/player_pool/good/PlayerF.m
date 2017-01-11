function board = PlayerF(board,color,time)

persistent endgame_tree

%% Pfade setzen und variablen declarieren
if ((180-time) <= eps(180))
    
    addpath( genpath( [ pwd '/players/PlayerF' ] ) );
    addpath( genpath( [ pwd '/PlayerF' ] ) );

    global PF_log_moves_total
    global PF_log_moves_count
    global PF_log_rotate
    global PF_log_old_board
    PF_log_moves_count = 0;
    PF_log_old_board = zeros(8);
    PF_log_old_board(4:5,4:5) = NaN;
    PF_log_rotate = 0;
    PF_log_moves_total = zeros(60,1, 'uint8');
    endgame_tree=[];

end


    
%% Zuege loggen
PF_logMove(board, color);

%% Main Body, try catch falls irgendwo ein Fehler gewrofen wird 
try

    %% Anfangszuege durchsuchen
    move=PF_getDatabaseMove(board, color);

    if ~isempty(move)
        disp('Spiele Datenbankzug...');
        board=PF_makeMove(board,color,move);
    else
        
        %% Suchtiefe definieren
        if (isempty(endgame_tree))
            move_count=ones(1,8)*abs(board)*ones(8,1);
            round_count=floor(move_count/2);
            [depth, sort_depth, perfectplay]=PF_evaluateDepth(board,time,round_count, color);
        else
            % endgame tree available, just make move
            perfectplay=1;
            depth=0;
            sort_depth=sum(board(:)==0); % just in case
        end
        if (perfectplay)
            disp(['PlayerF: perfect play, depth is ', num2str(sort_depth)]);
        else
            disp(['PlayerF: search depth is ', num2str(depth), ', sort depth is ', num2str(sort_depth)]);
        end

        %% Gueltige Zuege suchen
        legal=PF_validMoves(board,color);

        %% Wenn es gültige Zuege gibt, Minimax anwenden
        if ~isempty(legal)

            leglen=length(legal);

            alpha = -Inf;   

            if (sort_depth && perfectplay)
                %% End game
                if (isempty (endgame_tree))
                    disp ('Building game tree...');
                    endgame_tree = PF_negamax_sort( board, -color, sort_depth, perfectplay, 0);
                    endgame_tree = endgame_tree.sub(1);
                else
                    ind = cellfun(@(brd1)isequal(brd1,board),{endgame_tree.sub(:).pos});
                    if (find(ind))
                        disp ('Opponent move known.');
                        endgame_tree = endgame_tree.sub(ind).sub(1);
                    else
                        disp ('Building game tree...');
                        endgame_tree = PF_negamax_sort( board, -color, sort_depth, perfectplay, 0);
                        endgame_tree = endgame_tree.sub(1);
                    end
                end
                board = endgame_tree.pos;

            elseif (sort_depth)
                %% Midgame with move ordering
                tree=PF_negamax_sort( board, -color, sort_depth, perfectplay, 0);

                values = zeros(1,leglen);

                for l=1:leglen;
                   [values(l), brd.sub(l)] = PF_alphabeta( tree.sub(l), color, depth-1, -Inf, -alpha );
                    if (values(l)>alpha)
                        alpha=values(l);
                        ind = l;
                        %disp ([mfilename ': dp=', num2str(depth-1), sprintf('\t'), 'it=', num2str(l), '/', num2str(leglen),  sprintf('\t'), 'alpha=', num2str(alpha), sprintf('\t'), 'beta=Inf']);
                    end
                end
                brd.val = -alpha;
                brd.pos = board;

                %disp ([mfilename ': Values at depth ' num2str(depth-1) ':']);
                %disp (values);

                %disp ([mfilename ': Chosen value at depth ' num2str(depth-1) ': ' num2str(brd.val) ', index: ' num2str(ind)]);

                board=tree.sub(ind).pos;
            else
                %% Midgame without move ordering
                values = zeros(1,leglen);
                for l=1:leglen;
                    brd_new=PF_makeMove(board,color,legal(l));  

                    [values(l), brd.sub(l)] = PF_alphabeta( brd_new, color, depth-1, -Inf, -alpha );
                    if (values(l)>alpha)
                        alpha=values(l);
                        ind = l;
                        %disp ([mfilename ': dp=', num2str(depth), sprintf('\t'), 'it=', num2str(l), '/', num2str(leglen),  sprintf('\t'), 'alpha=', num2str(alpha), sprintf('\t'), 'beta=Inf']);
                    end
                end
                brd.val = -alpha;
                brd.pos = board;

                %disp ([mfilename ': Values at depth ' num2str(depth-1) ':']);
                %disp (values);

                %disp ([mfilename ': Chosen value at depth ' num2str(depth-1) ': ' num2str(brd.val) ', index: ' num2str(ind)]);

                board=PF_makeMove(board,color,legal(ind));
            end
        else
            disp('PlayerF: I have to pass...');
        end
    end

catch error1
    save e1.mat error1
    try
        legal=PF_validMoves(board,color);
        value=zeros(1,length(legal));
        for i=1:length(legal)
            value(1,i)=PF_evaluateMove(board,color);
        end
        [dummy,ind ]=max(value);
        board=PF_makeMove(board,color,legal(ind));
        disp('Used search depth=1 because of some error in the function');
        disp(error1);
        
    catch error2
        save e2.mat error2
        legal=PF_validMoves(board,color);
        board=PF_makeMove(board,color,legal(1));
        disp('Made first posible move because of some error even with search depth=1');
        disp(error2);
        
    end  
    
end

%% Zuege loggen
PF_logMove(board, color);

end