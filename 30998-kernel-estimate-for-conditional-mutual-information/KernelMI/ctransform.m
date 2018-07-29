function [ ar ] = ctransform(a)
% Copula-transform array - rank and scale to [0, 1]
    [as ai] = sort(a, 2);
    [aa ar] = sort(ai, 2);
    ar = (ar - 1) / (size(ar, 2) - 1);
end

