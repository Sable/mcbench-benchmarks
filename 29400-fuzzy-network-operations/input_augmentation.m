function [productBoolRB, productInputLTCounts, productOutputLTCounts] = input_augmentation(boolRB, inputLTCounts, outputLTCounts, augmentationPosition, augmentedInputLTCount)

%  This function performs input augmentation for a rule base. It is called
%  as follows:
% 
%  [productBoolRB, productInputLTCounts, productOutputLTCounts] =
%  input_augmentation(boolRB, inputLTCounts, outputLTCounts,
%  augmentationPosition, augmentedInputLTCount)
%  
%  where:
%
%  - productBoolRB is the Boolean matrix representation of the resultant
%  rule base.
%  - productInputLTCounts is an array that contains the counts of the
%  linguistic terms for each input to the resultant rule base.
%  - productOutputLTCounts is an array that contains the counts of the
%  linguistic terms for each output from the resultant rule base.
% 
%  - boolRB is the Boolean matrix representation of the rule base that is
%  to be augmented.
%  - inputLTCounts is an array that contains the counts of the linguistic
%  terms for each input to the rule base that is to be augmented.
%  - outputLTCounts is an array that contain the counts of the linguistic
%  terms for each output from the rule base that is to be augmented.
%  - augmentationPosition is the position of the augmented input in the
%  rule base that is to be augmented.
%  - augmentedInputLTCount is the number of linguistic terms for the
%  augmented input.
% 
%  Example: 
%  
%  N = [0 1 0; 0 0 1; 1 0 0];
%  [prodRB, inLT, outLT] = input_augmentation(N,[3],[3],1,3);
%  displ_bool_rb(prodRB, inLT, outLT);

% © Nedyalko Petrov, University of Portsmouth, UK
% email: nedyalko.petrov@port.ac.uk

numberOfInputs = length(inputLTCounts);
numberOfBoolRBRows = size(boolRB,1);

% Input data verification
if isempty(boolRB) || isempty(inputLTCounts) || isempty(outputLTCounts)
    disp('Incomplete input data');
    productBoolRB = [];
    productInputLTCounts = [];
    productOutputLTCounts = [];
    return;
end
    
if augmentationPosition > numberOfInputs + 1 || prod(inputLTCounts) ~= numberOfBoolRBRows || augmentationPosition < 1 || augmentedInputLTCount < 1
    disp('Incorrect input data');
    productBoolRB = [];
    productInputLTCounts = [];
    productOutputLTCounts = [];
    return;
end

% Find the overall number of input permutations for the resultant rule base.
numberOfInputPermutations = augmentedInputLTCount * prod(inputLTCounts);

% Find how many sequential rows from the initial rule base to be duplicated
% in the resultant rule base at a time. (The number of these rows coincides
% with the number of rows after which the value of the augmented input in
% the input permutations changes).
rowsToDuplicateCount = 1;
if augmentationPosition <= numberOfInputs
    rowsToDuplicateCount = prod(inputLTCounts(augmentationPosition:end));
end

% Define the initial indexes for the rows from the initial rule base to be
% duplicated.
currentRowsToDuplicateIndexes = 1 : rowsToDuplicateCount;

% Define the initial indexes for the rows from the resultant rule base to
% contain the duplicated rows from the initial rule base.
currentProductRBRowsIndexes = 1 : rowsToDuplicateCount;

% Fill the resultant rule base with zeros. 
productBoolRB = zeros(numberOfInputPermutations, prod(outputLTCounts));

% Fill the data in the resultant rule base.
while (currentRowsToDuplicateIndexes(end) <= numberOfBoolRBRows)
    for i = 1 : augmentedInputLTCount
        productBoolRB(currentProductRBRowsIndexes,:) = boolRB(currentRowsToDuplicateIndexes,:);
        currentProductRBRowsIndexes = currentProductRBRowsIndexes + rowsToDuplicateCount;
    end
    currentRowsToDuplicateIndexes = currentRowsToDuplicateIndexes + rowsToDuplicateCount;
end

productInputLTCounts = [inputLTCounts(1:augmentationPosition - 1) augmentedInputLTCount inputLTCounts(augmentationPosition:end)];
productOutputLTCounts = outputLTCounts;

% Uncomment the next line to display the resultant rule base to the screen.
% display_matrix(productBoolRB, productInputLTCounts, productOutputLTCounts);




