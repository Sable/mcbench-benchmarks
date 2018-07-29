function [nodes, edges, ages,error] = edgeManagement(Input,nodes,edges,ages,error,distances,params)  %#codegen

age_inc   = params(1);
max_age = params(2);
            eb = params(4);
            en = params(5);
            s1 = params(10);
            s2 = params(11);

NumOfNodes = size(nodes,2);

% Step 3. Increment the age of all edges emanating from s1. 
s1_Neighbors = find(edges(:,s1)==1);
SizeOfNeighborhood = length(s1_Neighbors);

ages(s1_Neighbors,s1) = ages(s1_Neighbors,s1) + age_inc;
ages(s1,s1_Neighbors) = ages(s1_Neighbors,s1);

% Step 4. Add the squared distance to a local error counter variable:
error(s1) = error(s1) + distances(s1)^2;

% Step 5. Move s1 and its topological neighbors towards î.
nodes(:,s1) = nodes(:,s1) + eb*(Input-nodes(:,s1));
nodes(:,s1_Neighbors) = nodes(:,s1_Neighbors) + en*(repmat(Input,[1 SizeOfNeighborhood])-nodes(:,s1_Neighbors));

% Step 6.
% If s1 and s2 are connected by an edge, set the age of this edge to zero.
% If such an edge does not exist, create it.
edges(s1,s2) = 1;
edges(s2,s1) = 1;
ages(s1,s2) = 0;
ages(s2,s1) = 0;

% Step 7. Remove edges with an age>max_age.
[DelRow DelCol] = find(ages>max_age);
SizeDeletion = length(DelRow);
for i=1:SizeDeletion
    edges(DelRow(i),DelCol(i)) = 0;
      ages(DelRow(i),DelCol(i)) = NaN;
end

% MEX-code generation:

% mexcfg = coder.config('mex');
% mexcfg.DynamicMemoryAllocation = 'AllVariableSizeArrays'; 
% codegen -config mexcfg edgeManagement.m -args {coder.typeof(In(:,n),[Inf 1]),coder.typeof(nodes,[Inf Inf]),coder.typeof(edges,[Inf Inf]),coder.typeof(ages,[Inf Inf]),coder.typeof(error,[1 Inf]),coder.typeof(distances,[1 Inf]),coder.typeof(params,[11,1])}
