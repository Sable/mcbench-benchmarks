function [relatMat] = convert_matrix(boolMat, inputLTCounts, outputLTCounts)

% This function converts a Boolean matrix representation of a rule base
% into a binary relational representation.
%
% It is called as follows:
%
% [relatMat] = convert_matrix(boolMat, inputLTCounts, outputLTCounts)
% 
%  where: 
%
%  - relatMat is the converted rule base.
%
%  - boolRB is the Boolean matrix representation of the rule base that is
%  to be converted.
%  - inputLTCounts is an array that contains the counts of the linguistic
%  terms for each input to the rule base that is to be converted.
%  - outputLTCounts is an array that contains the counts of the linguistic
%  terms for each output from the rule base that is to be converted.

% © Nedyalko Petrov, University of Portsmouth, UK
% email: nedyalko.petrov@port.ac.uk

[h l] = size(boolMat);
a = 1;
for i = 1 : h 
    for j = 1 : l
        if boolMat(i,j) == 1
                inputPerms = generate_permutations(inputLTCounts);
                outputPerms = generate_permutations(outputLTCounts);
                relatMat{a,1} = inputPerms{i};
                relatMat{a,2} = outputPerms{j};
                a = a + 1;  
        end
    end   
end