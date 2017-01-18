function board = PWND_stringToBoard(string)
  board = zeros(64,1);
  for ii = 1:64
    c = string(ii);
    switch c
      case '-'
        b = 0;
      case {'X', 'x'}
        b = -1;
      case {'O', 'o'}
        b = 1;
      otherwise
        error([mfilename,': not recognized format']);
    end
    board(ii) = b;
  end
  board = reshape(board, 8, 8);
  board = board.';
end