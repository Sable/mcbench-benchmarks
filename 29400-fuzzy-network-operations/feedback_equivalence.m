function [productBoolRB, productInputLTCounts, productOutputLTCounts] = feedback_equivalence(inputLTCounts, outputLTCounts, feedbackIndexes)

%  This function performs feedback equivalence for a rule base. It is
%  called as follows:
% 
%  [productBoolRB, productInputLTCounts, productOutputLTCounts] =
%  feedback_equivalence(inputLTCounts, outputLTCounts, feedbackIndexes)
% 
% where:
%
%  - productBoolRB is the Boolean matrix representation of the resultant
%  rule base.
%  - productInputLTCounts is an array that contains the counts of the
%  linguistic terms for each input to the resultant rule base.
%  - productOutputLTCounts is an array that contains the counts of the
%  linguistic terms for each output from the resultant rule base.
% 
%  - inputLTCounts is an array that contains the counts of the linguistic
%  terms for each input to the rule base that is to be equivalenced.
%  - outputLTCounts is an array that contains the counts of the linguistic
%  terms for each output from the rule base that is to be equivalenced.
%  - feedbackIndexes is an array with two columns, such that each row of
%  this array [Yi,Xi] represents an existing feedback connection from an
%  output with position Yi to an input with position Xi within the rule
%  base that is to be equialenced.
% 
%  Example:
% 
%  [prodRB, inLT, outLT] = feedback_equivalence([2 2],[2 2],[1 1]);
%  displ_bool_rb(prodRB, inLT, outLT);

% © Nedyalko Petrov, University of Portsmouth, UK
% email: nedyalko.petrov@port.ac.uk

% Input data verification
maxIndexes = max(feedbackIndexes, [], 1);
if maxIndexes(2) > length(inputLTCounts) || maxIndexes(1) > length(outputLTCounts)
    disp('Incorrect input data');
    productBoolRB = [];
    productInputLTCounts = [];
    productOutputLTCounts = [];
    return;
end

% Generate the input and output permutations for the initial rule base. 
inputPermutations = generate_permutations(inputLTCounts);
outputPermutations = generate_permutations(outputLTCounts);

% Fill the resultant rule base with zeros.
inPermCount = length(inputPermutations);
outPermCount = length(outputPermutations);
productBoolRB = zeros(inPermCount, outPermCount);

% Fill the data in the resultant rule base.
numberOfFeedbacks = size(feedbackIndexes,1);
for i = 1 : inPermCount
    for j = 1 : outPermCount
        for k = 1 : numberOfFeedbacks
            if inputPermutations{i}(feedbackIndexes(k,2)) == outputPermutations{j}(feedbackIndexes(k,1))
                productBoolRB(i, j) = 1;
            end
        end
    end
end

productInputLTCounts = inputLTCounts;
productOutputLTCounts = outputLTCounts;

% Uncomment the next line to display the resultant rule base to the screen.
% display_matrix(productBoolRB, productInputLTCounts, productOutputLTCounts);

