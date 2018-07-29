function score = visualize(board,goal,solutionVector)
solutionVector = validateSolutionVector(solutionVector, board);
boardToScore  = runSolutionVector(solutionVector, board, goal, true);
score = sum(boardToScore(:)) + sum(solutionVector);
