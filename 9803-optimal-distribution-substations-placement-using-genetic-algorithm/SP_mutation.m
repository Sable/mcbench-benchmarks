% this function is dedicated for crossover operation used by MATLAB ga
% function.
function mutationChildren = SP_mutation(parents ,options,NVARS, ...
    FitnessFcn, state, thisScore,thisPopulation,mutationRate)

mutationChildren = cell(length(parents),1);% Normally zeros(length(parents),NVARS);
for i=1:length(parents)
    parent = thisPopulation{parents(i)}; % Normally thisPopulation(parents(i),:)
    p = ceil(length(parent) * rand(1,2));
    child = parent;
    child(p(1)) = parent(p(2));
    child(p(2)) = parent(p(1));
    mutationChildren{i} = child; % Normally mutationChildren(i,:)
end