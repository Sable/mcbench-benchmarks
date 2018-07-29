function [boolRB,inputLTCounts,outputLTCounts] = horizontal_merging(boolRB1,inputLTCountsRB1,outputLTCountsRB1,boolRB2,inputLTCountsRB2,outputLTCountsRB2)

% This function performs horizontal merging of two rule base. It is called
% as follows:
% 
%  [boolRB,inputLTCounts,outputLTCounts] =
%  horizontal_merging(boolRB1,inputLTCountsRB1,outputLTCountsRB1,boolRB2, 
%  inputLTCountsRB2,outputLTCountsRB2);
% 
%  where:
%
%  - boolRB is the Boolean matrix representation of the resultant rule
%  base.
%  - inputLTCounts is an array that contains the counts of the linguistic
%  terms for each input to the resultant rule base.
%  - outputLTCounts is an array that contains the counts of the linguistic
%  terms for each output from the resultant rule base.
% 
%  - boolRB1 is the Boolean matrix representation of the first rule base
%  that is to be merged.
%  - boolRB2 is the Boolean matrix representation of the second rule base
%  that is to be merged.
%  - inputLTCountsRB1 is an array that contains the counts of the
%  linguistic terms for each input to the first rule base that is to be
%  merged.
%  - inputLTCountsRB2 is an array that contains the counts of the
%  linguistic terms for each input to the second rule base that is to be
%  merged.
%  - outputLTCountsRB1 is an array that contains the counts of the
%  linguistic terms for each output from the second rule bases that is to
%  be merged.
%  - outputLTCountsRB2 is an array that contains the counts of the
%  linguistic terms for each output from the second rule bases that is to
%  be merged.
% 
%  Example:
% 
%  boolRB1 = [0 1 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
%  boolRB2 = [0 0 0 0; 1 1 0 0; 0 0 0 1; 0 0 1 0];
%  [boolRB,inputLTCounts,outputLTCounts] = horizontal_merging(boolRB1,
%  [2 2], [2 2], boolRB2, [2 2], [2 2]);
%  display_matrix(boolRB, inputLTCounts, outputLTCounts);

% © Nedyalko Petrov, University of Portsmouth, UK
% email: nedyalko.petrov@port.ac.uk

inputLTCounts = inputLTCountsRB1;
outputLTCounts = outputLTCountsRB2;

% Check if the two rule bases are compatible
if size(boolRB1,2) == size(boolRB2,1) 
    % multiply the two matrices
    boolRB = boolRB1 * boolRB2;
    % convert the product matrix to a Boolean one
    for i = 1 : size(boolRB,1)
        for j = 1 : size(boolRB,2)
            if boolRB(i,j) ~= 0
                boolRB(i,j) = 1;
            end
        end
    end
else
    fprintf('\n');
    disp('Dimension mismatch: the number of rules in RB2 must be equal');
    disp('to the number of permutations of linguistic terms of the output from RB1');
    fprintf('\n');
    boolRB = [];
    inputLTCounts = [];
    outputLTCounts = [];
end