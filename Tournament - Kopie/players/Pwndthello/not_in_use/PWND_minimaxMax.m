

function [sc,bestBoard] = PWND_minimaxMax(b, color, depth)
  %disp(['in minimax_max'])
  sc = -inf;
  bestBoard = b;

  if depth == 0
    sc = PWND_evaluateBoard(b, -color);
  else
    pos = PWND_findAllowedPositions(b, color);
    if isempty(pos)
      disp('no moves possible')
      sc = evaluateBoard(b, -color);
      return;
    end
    for ii=1:size(pos, 1)
      bnew = PWND_makeMove(b, color, pos(ii,1), pos(ii,2));
      val = PWND_minimaxMin(bnew, color, depth-1);
      if val > sc
        sc = val;
        bestBoard = bnew;
      end 
    end 
  end
end