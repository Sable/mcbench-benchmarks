function idxmap = clustermap(idx)
%CLUSTERMAP Cluster map.
% IDXMAP = CLUSTERMAP(IDX,CENTERS) takes an N-by-1 vector of integers,
% computes the unique set of integers from that vector, and maps each
% integer in the first vector to the index where that integer occurs in the
% second vector.
% Copyright (2009) Sandia Corporation. Under the terms of Contract 
% DE-AC04-94AL85000 with Sandia Corporation, the U.S. Government retains 
% certain rights in this software.

centers = unique(idx)

for i = 1:size(idx,1)
    for j = 1:size(centers,1)
        if idx(i) == centers(j);
            idxmap(i,1) = j;
        end
    end
end