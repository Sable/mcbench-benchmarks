function child  = crossoverParents(p1,p2)
% Oren Rosen
% The MathWorks
% 8/29/2007
%
% This custom crossover function is written to work on a population of
% vectors of zeros and ones with the same amount of ones in each vector.
% The children that are produced from 2 parents will have the same genes
% for every element they agree on, and random choices of zerps and ones for
% the elements they don't agree on. The number of each is set so that all
% children have the same number of ones as their parents. All children
% automatically satisfy this constraint so there is no need to impose these
% constraints.


% *** Calculate dimensions of p1 (assume p2 matches) ***
numBits = length(p1);
num1s = sum(p1);

% *** Initialize child to all zeros ***
child = zeros(1,numBits);

% *** Need this later ***
indexVec = 1:numBits;

% *** Find Matching 1's and 0's ***
% Ex: If           p1 == [ 1 0 1 0 0 1 1 0 0 0 ]
%                  p2 == [ 1 0 0 1 0 0 1 0 1 0 ]
%     Then matching1s == [ 1 0 0 0 0 0 1 0 0 0 ]
%     Then matching0s == [ 0 1 0 0 1 0 0 1 0 1 ]
matching1s = ~xor(p1,p2) & (p1 == 1);
matching0s = ~xor(p1,p2) & (p1 == 0);
    
% *** Find Matching Indices ***
%     If       matching1s == [ 1 0 0 0 0 0 1 0 0 0 ]
%              matching0s == [ 0 1 0 0 1 0 0 1 0 1 ]
%     Then matching1sIndx == [ 1 7 ]
%          matching0sIndx == [ 2 5 8 10 ]
%         nonmatchingIndx == [ 3 4 6 9 ]
matching1sIndx = indexVec(matching1s);
matching0sIndx = indexVec(matching0s);
nonmatchingIndx = setdiff(indexVec,[matching0sIndx,matching1sIndx]);

% *** Create Child ***
% Ex: If   num1s == 4
%          matching1sIndx == [ 1 7 ]
%          nonmatchingIndx == [ 3 4 6 9 ]
%     Then numMatching1s == 2
%     num1sToFill == 2
%     Indx1sToFill == 2 random choices from [ 3 4 6 9 ]
numMatching1s = numel(matching1sIndx);
num1sToFill = num1s - numMatching1s;
Indx1sToFill = randsample(nonmatchingIndx,num1sToFill);

% *** Fill in 1s ***
% Ex: If      p1 == [ 1 0 1 0 0 1 1 0 0 0 ]
%             p2 == [ 1 0 0 1 0 0 1 0 1 0 ]
%     Then child == [ 1 0 ? ? 0 ? 1 0 ? 0 ]
%     With exactly 2 of the '?' equal to 1, the rest 0.
child(matching1sIndx) = 1;
child(Indx1sToFill) = 1;

% *** Display results ***
disp(' ');
disp(['Given: parent1 = [ ',num2str(p1),' ]']);
disp(['       parent2 = [ ',num2str(p2),' ]']);
disp(' ');
disp(['         child = [ ',num2str(child),' ]']);