function [s1 s2 distances] = findTwoNearest(Input,nodes) %#codegen

NumOfNodes = size(nodes,2);

distances = zeros(1,NumOfNodes);
for i=1:NumOfNodes
    distances(i) = norm(Input - nodes(:,i));
end

[sdistances indices] = sort(distances);

s1 = indices(1);
s2 = indices(2);

% MEX Code Generation:

% mexcfg = coder.config('mex');
% mexcfg.DynamicMemoryAllocation = 'AllVariableSizeArrays'; 
% codegen -config mexcfg findTwoNearest -args {coder.typeof(In(:,n),[Inf 1]),coder.typeof(nodes,[Inf Inf])}