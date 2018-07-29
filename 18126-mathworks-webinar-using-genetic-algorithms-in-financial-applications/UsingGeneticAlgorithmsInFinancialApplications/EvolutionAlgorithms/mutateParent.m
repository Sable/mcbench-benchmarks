function child = mutateParent(parent)
% Oren Rosen
% The MathWorks
% 8/29/2007
%
% This custom mutation function is written to work on a population of
% vectors of zeros and ones with the same amount of ones in each vector.
% The mutated child is formed by randomly permuting the elements of the
% parent.
% Note: Performance-wise this hasn't worked out to be that efficient. A
% better implementation may swap only two of the elements.

% *** Calculate dimensions of parent ***
numBits = length(parent);

% *** Randomly permute bits
child = parent( randperm(numBits) );

% *** Display results ***
disp(' ');
disp(['Given: parent = [ ',num2str(parent),' ]']);
disp(' ');
disp(['        child = [ ',num2str(child),' ]']);


