function [idx, B] = PWND_findAllowedPositions1(b, color)
  % find all possible positions for the next turn 

  
  idx = [];
  B = [];
  
  b_cpy = b;
  [M, N] = find(b == -color);

  % we can have a maximum of ...
  M_allowed = zeros(64-length(M), 1);
  N_allowed = zeros(64-length(N), 1);
  B_allowed = zeros(8, 8, 64-length(M));

  jj = 1;

  while numel(M)

    m = M(1);
    n = N(1);
    %disp(['checking environment of (', num2str(m), ',', num2str(n), ')']);

    % check north 
    if (m-1 >= 1) && b(m-1, n) == 0
      [bnew, changed] = PWND_makeMove(b_cpy, color, m-1, n);
      if changed
        M_allowed(jj,1) = m-1;
        N_allowed(jj,1) = n;
        B_allowed(:,:,jj) = bnew;
        b(m-1,n) = 2;
        jj = jj+1;
      end
    end  
    % check north-east
    if (m-1 >= 1) && (n+1 <= 8) && b(m-1,n+1) == 0
      [bnew, changed] = PWND_makeMove(b_cpy, color, m-1, n+1);
      if changed
        M_allowed(jj,1) = m-1;
        N_allowed(jj,1) = n+1;
        B_allowed(:,:,jj) = bnew;
        b(m-1,n+1) = 2;
        jj = jj+1;
      end
    end 
    % check east
    if (n+1 <= 8) && b(m, n+1) == 0
      [bnew, changed] = PWND_makeMove(b_cpy, color, m, n+1);
      if changed
        M_allowed(jj,1) = m;
        N_allowed(jj,1) = n+1;
        B_allowed(:,:,jj) = bnew;
        b(m,n+1) = 2;
        jj = jj+1;
      end
    end 
    % check south-east
    if (m+1 <= 8) && (n+1 <= 8) && b(m+1,n+1) == 0
      [bnew, changed] = PWND_makeMove(b_cpy, color, m+1, n+1);
      if changed
        M_allowed(jj,1) = m+1;
        N_allowed(jj,1) = n+1;
        B_allowed(:,:,jj) = bnew;
        b(m+1,n+1) = 2;
        jj = jj+1; 
      end
    end
    % check south
    if (m+1 <= 8) && b(m+1,n) == 0
      [bnew, changed] = PWND_makeMove(b_cpy, color, m+1, n);
      if changed
        M_allowed(jj,1) = m+1;
        N_allowed(jj,1) = n;
        B_allowed(:,:,jj) = bnew;
        b(m+1,n) = 2;
        jj = jj+1; 
      end
    end
    % check south-west
    if (m+1 <= 8) && (n-1 >= 1) && b(m+1,n-1) == 0
      [bnew, changed] = PWND_makeMove(b_cpy, color, m+1, n-1);
      if changed
        M_allowed(jj,1) = m+1;
        N_allowed(jj,1) = n-1;
        B_allowed(:,:,jj) = bnew;
        b(m+1,n-1) = 2;
        jj = jj+1; 
      end
    end
    % check west
    if (n-1 >= 1) && b(m,n-1) == 0
      [bnew, changed] = PWND_makeMove(b_cpy, color, m, n-1);
      if changed
        M_allowed(jj,1) = m;
        N_allowed(jj,1) = n-1;
        B_allowed(:,:,jj) = bnew;
        b(m,n-1) = 2;
        jj = jj+1; 
      end
    end
    % check north-west
    if (m-1 >= 1) && (n-1 >= 1) && b(m-1,n-1) == 0
      [bnew, changed] = PWND_makeMove(b_cpy, color, m-1, n-1);
      if changed
        M_allowed(jj,1) = m-1;
        N_allowed(jj,1) = n-1;
        B_allowed(:,:,jj) = bnew;
        b(m-1,n-1) = 2;
        jj = jj+1;
      end
    end
    M = M(2:end);
    N = N(2:end); 
  end

  
  % shrink them to their real size (i.e. omits all trailing
  % zeros that were previously reserved for possible entries
  real_items = (M_allowed ~= 0);
  M_allowed = M_allowed(real_items);
  N_allowed = N_allowed(real_items);
  B = B_allowed(:,:,real_items);
  idx = [M_allowed N_allowed];
    
end
