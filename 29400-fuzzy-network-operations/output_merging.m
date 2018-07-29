function [boolRB,inputLTCounts,outputLTCounts] = output_merging(boolRB1,inputLTCountsRB1,outputLTCountsRB1,boolRB2,inputLTCountsRB2,outputLTCountsRB2)

% This function performs output merging of two rule bases. It is called as
% follows:
% 
%  [boolRB,inputLTCounts,outputLTCounts] =
%  output_merging(boolRB1,inputLTCountsRB1,outputLTCountsRB1,boolRB2,
%  inputLTCountsRB2,outputLTCountsRB2)
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
%  boolRB1 = [1 1; 1 0; 0 1; 0 0];
%  boolRB2 = [0 1; 1 0; 1 0; 0 0];
%  [boolRB,inputLTCounts,outputLTCounts] = output_merging(boolRB1, [2 2],
%  [2], boolRB2, [2 2], [2]);
%  display_matrix(boolRB,inputLTCounts,outputLTCounts);

% © Nedyalko Petrov, University of Portsmouth, UK
% email: nedyalko.petrov@port.ac.uk

% Create a Boolean matrix with rows that represent all possible
% permutations of the linguistic terms of the inputs and columns that
% represent all possible permutations of the linguistic terms of the
% outputs from the resultant rule base

inputLTCounts = inputLTCountsRB1; 
outputLTCounts = cat(2,outputLTCountsRB1,outputLTCountsRB2);
inpPerm = generate_permutations(inputLTCounts);
outPerm = generate_permutations(outputLTCounts);

boolRB = zeros(length(inpPerm),length(outPerm));

% Get the relational representation of the Boolean matrixes to be merged 
relatRB1 = convert_matrix(boolRB1,inputLTCountsRB1,outputLTCountsRB1);
relatRB2 = convert_matrix(boolRB2,inputLTCountsRB2,outputLTCountsRB2);

hpermMat = 0;
for i = 1 : size(relatRB1,1)
    for j = 1 : size(relatRB2,1)
        if (relatRB1{i,1} == relatRB2{j,1})
            hpermMat = hpermMat + 1;
            permMat{hpermMat,1} = relatRB1(i,1);
            permMat{hpermMat,2} = cat(2,relatRB1{i,2},relatRB2{j,2});
        end
    end
end

% Write ones where necessary
for i = 1 : size(boolRB,1)
    for j = 1 : size(boolRB,2)
        for k = 1 : size(permMat,1)
            if min(inpPerm{i} == permMat{k,1}{1}) && min(outPerm{j} == permMat{k,2})
                boolRB(i,j) = 1;
            end
        end
    end
end