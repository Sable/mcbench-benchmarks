% this function is dedicated for crossover operation used by MATLAB ga
% function.
function xoverKids  = SP_crossover(parents,options,NVARS, ...
    FitnessFcn,thisScore,thisPopulation)

nKids = length(parents)/2;
xoverKids = cell(nKids,1); % Normally zeros(nKids,NVARS);
index = 1;
for i=1:nKids
    parent = thisPopulation{parents(index)};
    index = index + 2;
    % Flip a section of parent1.
    p1 = ceil((length(parent) -1) * rand);
    p2 = p1 + ceil((length(parent) - p1- 1) * rand);
    child = parent;
    child(p1:p2) = fliplr(child(p1:p2));
    xoverKids{i} = child; % Normally, xoverKids(i,:);
end