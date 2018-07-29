function [bmu secbmu distances] = findTwoClosest(Input,nodes)

% Given an input data pont as an N-dimensional vector, this function
% finds the 2 closest DCS neural units to it.
% The calculation is based on the Euclidean distance (L2 norm).
% It returns the Best Matching Unit (bmu) and the Second Best Matching
% Unit (secbmu) and the distances of all nodes to the input data point.

NumOfNodes = size(nodes,2);
distances = zeros(1,NumOfNodes);

% Find 2 closest nodes to current input pattern.
for i=1:NumOfNodes
     distances(i) = norm(Input - nodes(:,i));
end

[sdistances indices] = sort(distances);

bmu       = indices(1);
secbmu = indices(2);