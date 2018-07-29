function solutionVector = validateSolutionVector(solutionVector, board)
% remove forbidden values (walls and values not in board) and ensure a
% column vector for solutionVector

solutionVector = solutionVector(:); %ensure column
solutionVector(numel(board)+1:end) = [];
forbiddenValues = setdiff(solutionVector, board(:));

% setdiff([1 2 3], 1)
% ans =  2     3
% 
% setdiff(1, [1 2 3])
% ans =  []

forbiddenValues = [0; forbiddenValues(:)]; %no walls allowed!

%remove forbidden values
for i = 1 : numel(forbiddenValues)
    solutionVector(solutionVector == forbiddenValues(i)) = [];
end