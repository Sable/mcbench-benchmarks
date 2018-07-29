function [linktable, featuremat] = points_link(bw, ptcore, ptmarg, R, NeighborNum)

% This function links the current point and its neighbour points
% The structure of node: current point, number of neighbors, neighbor 1,
% linkpoint, neighbour 2, linkpoint,...

if (nargin == 4)
   NeighborNum = 3; 
end

pt= [ptcore(:); ptmarg(:)];
labelmap = points_show(bw, pt, R, false);

seeds = ptcore;
npix = prod(size(seeds));
linktable = [];
featuremat =[];

for k = 1:npix
    seed = seeds(k);
    [node, featurevec] = point_neighbors(bw, pt, R, seed, NeighborNum, labelmap);
    linktable = [linktable; node];
    featuremat = [featuremat; featurevec];
end