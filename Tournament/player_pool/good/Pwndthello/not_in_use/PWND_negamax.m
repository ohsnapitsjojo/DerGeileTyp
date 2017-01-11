
function [sc, bestBoard] = PWND_negamax(b, color, depth)
  %disp(['in minimax_max'])
  sc = -inf;
  bestBoard = b;

  if depth == 0
    sc = PWND_evaluateBoard(b, color);
    disp(['Returning a value of ' num2str(sc) ' for color ' num2str(color)]);
  else
    pos = PWND_findAllowedPositions(b, color);
    if isempty(pos)
      disp([mfilename, ': no moves possible'])
      sc = PWND_evaluateBoard(b, color); % might have to be changed ...
      return;
    end
    for ii=1:size(pos, 1)
      bnew = PWND_makeMove(b, color, pos(ii,1), pos(ii,2));
      val = -PWND_negamax(bnew, -color, depth-1);
      if val > sc || val == inf
        if val == inf
            disp('thats why')
        end
        sc = val;
        bestBoard = bnew;
      end 
    end 
  end
end