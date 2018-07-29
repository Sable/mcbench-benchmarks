function points = points_transform(node, dim, startorder);

% This function extract the bifurcation coordinate from the node

if (nargin == 2)
   startorder = 1; 
end

M = dim(1);
N = dim(2);
base_points = [];

seeds = node(1:2:end)';
if (startorder ~=1)
    seeds(2:end) = circshift(seeds(2:end), [startorder-1, 0]);
end

posi = mod(seeds, M);
posi(find(posi==0))= M; 
posj = 1 + (seeds-posi)/M;
points = [posj, posi]; 