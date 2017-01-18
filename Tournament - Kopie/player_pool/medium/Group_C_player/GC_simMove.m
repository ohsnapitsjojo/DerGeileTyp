%  @brief Given a sequence of 2D coordinates (x,y) with x in [1,8] and y in
%  [1,8] this function computes the board snapshot after each move and
%  returns those.
%  
%  @author Martin Becker
%  @date 2011-Jan-15
%  @last-change if coords is empty, then the initial board is returned.
% 
%  @callgraph
%  @callergraph
% 
% @param coords an n-by-2 list of 2D coordinates. if empty the initial
%     board is returned. elements (:,1) are the row coordinates, elements (:,2)
%     the column coordinates (each integer within [1,8]).
% @param initBoard (optional) if a constellation of a board is given, the
%     function expands that. If omitted, the function starts with an initial
%     board.
% @param color (optional) the color which's turn it is on initBoard. If
%     omitted black (=-1) is assumed.
% 
% @retval seqBoards 8-by-8-by-n matrix returning the boards resulting AFTER
%     the moves given by coords.
function [ seqBoards ] = GC_simMove(coords, color, initBoard)

seqBoards = [];
if (nargin < 3)
    initBoard = zeros(8);    
    initBoard(4:5,4:5) = [ 1 , -1;      % assumption: black is mapped to -1.
                          -1 ,  1];
end

if (nargin < 2)
    color = -1; % starts with black
end

if (nargin == 0)
    % return initial board
    seqBoards = initBoard;
    return;
end

XDir = [-1 -1 0 +1 +1 +1 0 -1]; % counter clockwise directions starting from West
YDir = [0 +1 +1 +1 0 -1 -1 -1];
%color = -1;   % assumption: black is -1 and I am black.

for k = 1:size(coords,1)
    XPos = coords(k,2);     % start at the new disk.
    YPos = coords(k,1);
   
    % set new disk.
    initBoard(YPos,XPos) = color;
    
    for dir=1:8
      count=1;  % count = 2;
      %between=[];
      valid = 0;
      while(1)
         markerX = XPos + count*XDir(dir);
         markerY = YPos + count*YDir(dir);
         if (markerX<1) || (markerX>8) || (markerY<1) || (markerY>8)   % board limits exceeded -> stop.
            break;
         elseif (initBoard(markerY,markerX)==color)                 % if my own color was found -> potential trap complete. stop.
            if count > 1
                valid = 1;
            end
            break;
            %valid = 1;
            %between = [between initBoard(markerY-YDir(dir),markerX-XDir(dir))];
         elseif (initBoard(markerY,markerX)==-color)                % hit opponent -> okay
             % trapping opponent -> yep!
             count = count+1;
             %between = [between initBoard(markerY,markerX)];
         else                                                       % hit empty field -> break.
             break;
             %done = 1;
         end
      end
      
      % this direction is done. flip disks if allowed.
      if valid
          for i=1:(count-1)
              initBoard(YPos+YDir(dir)*i,XPos+XDir(dir)*i) = color;  
          end
      end
    end % for dir
    
    % invert color for next move
    color = -1*color;
    
    % append board to the return list
    seqBoards = cat (3, seqBoards, initBoard);
end %k