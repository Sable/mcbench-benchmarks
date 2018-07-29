function mutationChildren = mutationNcK(parents,options,GenomeLength,FitnessFcn,state,thisScore,thisPopulation)
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

 
mutationChildren = zeros(length(parents),GenomeLength);
numVars = length(thisPopulation(1,:));

for i=1:length(parents)
    child = thisPopulation(parents(i),:);
    mutationChildren(i,:) = child( randperm(numVars) );
end

