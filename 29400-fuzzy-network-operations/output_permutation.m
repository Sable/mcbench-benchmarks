function [productBoolRB, productInputLTCounts, productOutputLTCounts] = output_permutation(boolRB, inputLTCounts, outputLTCounts, newOutputPermutation)

%  This function performs output permutation of a rule base. It is called
%  as follows:
%  
%  [productBoolRB, productInputLTCounts, productOutputLTCounts] =
%  output_permutation(boolRB, inputLTCounts, outputLTCounts,
%  newOutputPermutation)
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
%  - boolRB is the Boolean matrix representation of the rule base to be
%  permuted.
%  - inputLTCounts is an array that contains the counts of the linguistic
%  terms for each input to the rule base that is to be permuted.
%  - outputLTCounts is an array that contains the counts of the linguistic
%  terms for each output from the rule base that is to be permuted.
%  - newOutputPermutation is an array that contains the output permutation
%  to be applied.
% 
%  Example:
% 
%  N = [0 0 0 0 0 1 0 0 0; 0 0 0 0 0 0 1 0 0; 0 1 0 0 0 0 0 0 0];
%  [prodRB, inLT, outLT] = output_permutation(N,[3],[3 3],[2 1]);
%  display_matrix(prodRB, inLT, outLT);

% © Nedyalko Petrov, University of Portsmouth, UK
% email: nedyalko.petrov@port.ac.uk

numberOfOutputs = length(outputLTCounts);

% Input data verification
if isempty(boolRB) || isempty(inputLTCounts) || isempty(outputLTCounts) || isempty(newOutputPermutation)
    disp('Incomplete input data');
    productBoolRB = [];
    productInputLTCounts = [];
    productOutputLTCounts = [];
    return;
end

if numberOfOutputs ~= length(newOutputPermutation)
    disp('Incorrect input data');
    productBoolRB = [];
    productInputLTCounts = [];
    productOutputLTCounts = [];
    return;
end

% Find the new weight of each LT position
weights = zeros(numberOfOutputs, 1);

for i = 1 : numberOfOutputs
    weights(newOutputPermutation(i)) = prod(outputLTCounts(i+1:end));
end

% Generate the output permutations for the initial rule base. 
permutations = generate_permutations(outputLTCounts);
numberOfPermutations = length(permutations);

% Find the new column index for each output permutation.
newPositions = zeros(numberOfPermutations, 1);
for i = 1 : numberOfPermutations
    newPositions(i) = 1;
    
    % The process of finding the new column index of each output
    % permutation is analogous to the conversion of base-X numerical
    % system to base-10 numerical system, where X is different for each
    % output permutation element and equals to the weight of that element.
    for j = 1 : numberOfOutputs
        newPositions(i) = newPositions(i) + (permutations{i}(j) - 1) * weights(j);
    end
end

% Fill the resultant rule base with zeros. 
productBoolRB = zeros(prod(inputLTCounts), numberOfPermutations);

% Fill the data in the resultant rule base.
for i = 1 : numberOfPermutations
    productBoolRB(:, newPositions(i)) = boolRB(:, i);
end

productInputLTCounts = inputLTCounts;

productOutputLTCounts = zeros(1,numberOfOutputs);
for i = 1 : numberOfOutputs
    productOutputLTCounts(i) = outputLTCounts(newOutputPermutation(i));
end

% Uncomment the next line to display the resultant rule base to the screen.
% display_matrix(productBoolRB, productInputLTCounts, productOutputLTCounts);




