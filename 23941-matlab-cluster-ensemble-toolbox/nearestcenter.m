function idx = nearestcenter(X,centers)
%NEARESTCENTER Nearest centers.
% IDX = NEARESTCENTER(X,CENTERS) returns an N-by-1 vector of indices,
% associated with the nearest center to a given point.  X is the N-by-D
% matrix of points and CENTERS is an M-by-D matrix of center locations. IDX
% is an N-by-1 vector of indices representing the index of the center closest
% to a given point.
%
% Copyright (2009) Sandia Corporation. Under the terms of Contract 
% DE-AC04-94AL85000 with Sandia Corporation, the U.S. Government retains 
% certain rights in this software.

for i = 1:size(X,1)
    for j = 1:size(centers,1)
        dist(j) = norm(X(i,:) - centers(j,:));
    end
    [y index] = min(dist);
    idx(i) = index;
end

idx = idx';