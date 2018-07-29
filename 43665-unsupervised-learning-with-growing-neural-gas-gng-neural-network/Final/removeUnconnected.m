function [nodes, edges, ages, error] = removeUnconnected(nodes, edges,ages,error) %#codegen

NumOfNodes = size(nodes,2);

i = 1;
while NumOfNodes >= i
    if any(edges(i,:)) == 0
        
        edges = [edges(1:i-1,:); edges(i+1:NumOfNodes,:);];
        edges = [edges(:,1:i-1)  edges(:,i+1:NumOfNodes);];
       
        ages = [ages(1:i-1,:); ages(i+1:NumOfNodes,:);];
        ages = [ages(:,1:i-1)  ages(:,i+1:NumOfNodes);];

        nodes = [nodes(:,1:i-1) nodes(:,i+1:NumOfNodes);];
        error = [error(1,1:i-1) error(1,i+1:NumOfNodes);];
        
        NumOfNodes = NumOfNodes - 1;
        
        i = i -1; 
    end
    i = i+1;
end

% MEX-code generation

% mexcfg = coder.config('mex');
% mexcfg.DynamicMemoryAllocation = 'AllVariableSizeArrays'; 
% codegen -config mexcfg removeUnconnected -args {coder.typeof(nodes,[Inf Inf]),coder.typeof(edges,[Inf Inf]),coder.typeof(ages,[Inf Inf]),coder.typeof(error,[1 Inf])}
