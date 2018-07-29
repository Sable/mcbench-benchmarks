function score = grade(board,goal,solutionVector)
modSolutionVector = validateSolutionVector(solutionVector,board);
boardToScore = runSolutionVector(modSolutionVector, board, goal, false);
score = sum(boardToScore(:)) + sum(modSolutionVector);
