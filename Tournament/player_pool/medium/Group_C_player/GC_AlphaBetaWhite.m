%  @brief Minimaximal with alpha-beta-pruning for when it's white's turn.
% 
%  @author Iurii Bereshchuk
%  @date 2011-Jan-24
% 
%  @callgraph
%  @callergraph
% 
% input arguments
%   @param Brett matrix 8-by-8 representing an Othello game board. fields
%   with 0 are empty, +1 and -1 are both players, respectively.
%   @param alpha alpha-bound for alpha-beta pruning
%   @param beta beta-bound for alpha-beta pruning
%   @depth search depth to go to at maximalimum
%   @param gameSequence an alphanumeric sequence indicating the othello moves
%       done up to now. This is required by the GC_getValidPositions() function.
%   @param roundno an integer value indicating the current round number,
%       starting at one, must not be negative.
% 
%   @retval best heuristic value of the chosen move
%   @retval bester_Zug 2-by-1 vector, describes the newly set disk as a coordinate
%       here. element (1,1) is the row coordinate, element (1,2) is the
%       column coordinate.
%   @retval bestes_Brett input argument Brett modified with bester_Zug and
%       its consequences.
% @comment M.Becker: I assume there is a path which doesn't do the intended
% thing, e.g. it might become possible that best_pos is empty, but line 62f
% is executed.
function [best,bester_Zug,bestes_Brett, dict_flag] = GC_AlphaBetaWhite(Brett,alpha,beta,depth,round_no,gameSequence)
    maximal=-Inf;
    bester_Zug=[];
    best_pos=[];
    bestes_Brett=[];

    %% MAXIMIZING PLAYER, WHITE. GC_AlphaBetaBlack() needs to return higher values when the board is better for white.
    
    if depth<=0
        best=GC_getBoardEvalBetter(Brett, 1, round_no);   % eval for white -> black (my caller) then tries to MINIMIZE. If we would get (Brett, -1), then black would need to MAXIMIZE.
    else
        [ possibleBoards, disksNew, dummy , dict_flag] = GC_getValidPositions(Brett, 1, round_no, gameSequence);  
        if ~isempty(disksNew)            
             
            % if dictionary is active and only one move is returned, 
                       
            if ((numel(dummy)==1) && ~strcmp(gameSequence,''))
                best = 1; % fake value
                bester_Zug=disksNew(:,1);
                bestes_Brett=possibleBoards(:,:,1);
            else
            
                for k=1:size(disksNew,2)

                    Brett_1=possibleBoards(:,:,k);
                    tmp=GC_AlphaBetaBlack(Brett_1,alpha,beta,depth-1, round_no+1,''); % NOTE: it is essential NOT to give a game sequence here. This confuses the dictionary.
                    if tmp>maximal
                        maximal=tmp;
                        best_pos=k;
                    end;
                    if  tmp>alpha
                       alpha=tmp;
                    end;
                    if  maximal>=beta
                        break;
                    end;
                end;
                best=maximal;
                bester_Zug=disksNew(:,best_pos);
                bestes_Brett=possibleBoards(:,:,best_pos);
            end
        else          
            % at least score the board and return
            best=GC_getBoardEvalBetter(Brett, 1, round_no);
            bestes_Brett=Brett;
        end;
    end;
 end


