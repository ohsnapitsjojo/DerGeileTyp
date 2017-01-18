function [idx] = PWND_findAllowedPositions(b, color)
  % find all possible positions for the next turn 
  %%disp('Occupied: ')
  
  idx = [];
  %disp(['in findAllowedPositions start, b'])
  [M, N] = find(b == -color);

  M_allowed = zeros(64-length(M), 1);
  N_allowed = zeros(64-length(N), 1);

  jj = 1;

  for ii=1:size(M, 1)
    m = M(ii);
    n = N(ii);
    %disp(['checking environment of (', num2str(m), ',', num2str(n), ')']);

    % check north 
    if (m-1 >= 1) && b(m-1, n) == 0
      %disp(['checking: (', num2str(m-1), ',', num2str(n), ')']);
      [bnew, changed] = PWND_makeMove(b, color, m-1, n);
      if changed
        M_allowed(jj,1) = m-1;
        N_allowed(jj,1) = n;
        jj = jj+1;
      end
    end  
    % check north-east
    if (m-1 >= 1) && (n+1 <= 8) && b(m-1,n+1) == 0
      %disp(['checking: (', num2str(m-1), ',', num2str(n-1), ')']);
      [bnew, changed] = PWND_makeMove(b, color, m-1, n+1);
      if changed
        M_allowed(jj,1) = m-1;
        N_allowed(jj,1) = n+1;
        jj = jj+1;
      end
    end 
    % check east
    if (n+1 <= 8) && b(m, n+1) == 0
      %disp(['checking: (', num2str(m), ',', num2str(n+1), ')']);
      [bnew, changed] = PWND_makeMove(b, color, m, n+1);
      if changed
        M_allowed(jj,1) = m;
        N_allowed(jj,1) = n+1;
        jj = jj+1;
      end
    end 
    % check south-east
    if (m+1 <= 8) && (n+1 <= 8) && b(m+1,n+1) == 0
      %disp(['checking: (', num2str(m+1), ',', num2str(n+1), ')']);
      [bnew, changed] = PWND_makeMove(b, color, m+1, n+1);
      if changed
        M_allowed(jj,1) = m+1;
        N_allowed(jj,1) = n+1;
        jj = jj+1; 
      end
    end
    % check south
    if (m+1 <= 8) && b(m+1,n) == 0
      %disp(['checking: (', num2str(m+1), ',', num2str(n), ')']);
      [bnew, changed] = PWND_makeMove(b, color, m+1, n);
      if changed
        M_allowed(jj,1) = m+1;
        N_allowed(jj,1) = n;
        jj = jj+1; 
      end
    end
    % check south-west
    if (m+1 <= 8) && (n-1 >= 1) && b(m+1,n-1) == 0
      %disp(['checking: (', num2str(m+1), ',', num2str(n-1), ')']);
      [bnew, changed] = PWND_makeMove(b, color, m+1, n-1);
      if changed
        M_allowed(jj,1) = m+1;
        N_allowed(jj,1) = n-1;
        jj = jj+1; 
      end
    end
    % check west
    if (n-1 >= 1) && b(m,n-1) == 0
      %disp(['checking: (', num2str(m), ',', num2str(n-1), ')']);
      [bnew, changed] = PWND_makeMove(b, color, m, n-1);
      if changed
        M_allowed(jj,1) = m;
        N_allowed(jj,1) = n-1;
        jj = jj+1; 
      end
    end
    % check north-west
    if (m-1 >= 1) && (n-1 >= 1) && b(m-1,n-1) == 0
      %disp(['checking: (', num2str(m-1), ',', num2str(n), ')']);
      [bnew, changed] = PWND_makeMove(b, color, m-1, n-1);
      if changed
        M_allowed(jj,1) = m-1;
        N_allowed(jj,1) = n-1;
        jj = jj+1;
      end
    end
  end
  
  % shrink them to their real size (i.e. omits all trailing
  % zeros that were previously reserved for possible entries
  M_allowed = M_allowed(M_allowed ~= 0);
  N_allowed = N_allowed(N_allowed ~= 0);
  idx = unique([M_allowed N_allowed], 'rows');
  
end
