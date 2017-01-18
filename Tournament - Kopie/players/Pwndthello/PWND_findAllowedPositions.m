function [idx, B] = PWND_findAllowedPositions(b, color)
  %% Find all allowed positions for the next turn of the given color
  % it uses the result of PWND_frontierDisk to get all theoretical
  % possible moves 
  %
  % this version is based upon previous approaches to optimize this function
  % that can be found in not_in_use/
  %
  % fst, 10/04/2012 - works!

  
  % retrieve a list of possible candidates for the next disc placement
  [M N] = PWND_frontierDisks(b, -color);

  % we can have a maximum of ...
  M_allowed = zeros(64-length(M), 1);
  N_allowed = zeros(64-length(N), 1);
  B_allowed = zeros(8, 8, 64-length(M));

 
  jj = 1;

  % now check the list of the candidates whether they really embody allowed
  % positions; this is done by calling PWND_makeMove which returns the flag
  % 'changed' indicating if the new board 'bnew' has been changed to the
  % previous one; if it has been changed, we have got a new valid board
  for ii = 1:size(M,1)
    [bnew, changed] = PWND_makeMove(b, color, M(ii), N(ii));
    if changed
      B_allowed(:,:,jj) = bnew;
      M_allowed(jj,1) = M(ii);
      N_allowed(jj,1) = N(ii);
      jj = jj + 1;
    end
  end

  
  % shrink them to their real size (i.e. omits all trailing
  % zeros that were previously reserved for possible entries
  real_items = (M_allowed ~= 0);
  M_allowed = M_allowed(real_items);
  N_allowed = N_allowed(real_items);
  B = B_allowed(:,:,real_items);
  idx = [M_allowed N_allowed];
    
end
