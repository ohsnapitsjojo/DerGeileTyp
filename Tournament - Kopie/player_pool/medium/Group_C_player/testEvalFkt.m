function eval = GC_testEvalFkt(board, color)
    [boardPack, movePack, flippedDisks] = GC_getValidPositions(board, color, 1, '');
    eval = GC_getBoardEval(board, movePack, flippedDisks, color, 1);
