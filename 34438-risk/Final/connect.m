function board = connect(board, a, b)

board(a).Neighbors(end+1) = b;
board(b).Neighbors(end+1) = a;

board(a).Neighbors = unique(board(a).Neighbors);
board(b).Neighbors = unique(board(b).Neighbors);