function nodes = restrictedKohonen(Input,C,nodes,bmu,eb,en)
% This function adjusts the location (weight) of the bmu and its neighbors
% in a Kohonen-like fashion.

NumOfNodes = size(nodes,2);

% First determine bmu neighborhood.    
bmu_Neighbors = find(C(:,bmu)~=0);
         
% Kohonen-like Update of bmu weights and its neighbors.
nodes(:,bmu) = nodes(:,bmu) + eb*(Input - nodes(:,bmu));

SizeOfNeighborhood = length(bmu_Neighbors);
for i=1:SizeOfNeighborhood
        nodes(:,bmu_Neighbors(i)) = nodes(:,bmu_Neighbors(i)) + en*(Input - nodes(:,bmu_Neighbors(i)));
end