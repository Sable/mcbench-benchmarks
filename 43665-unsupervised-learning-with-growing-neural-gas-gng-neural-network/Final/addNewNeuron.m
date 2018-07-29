function  [nodes,edges,ages,error] = addNewNeuron(nodes,edges,ages,error,alpha)  %#codegen 
                                                                                                                                    % Checks whether this function is
                                                                                                                                    % suitable for automatic .mex code generation.
NumOfNodes = size(nodes,2);
    
[max_error q] = max(error);
       
% Find q-Neighborhood
  q_Neighbors = find(edges(:,q)==1);
  
% Find the neighbor f with the largest accumulated error. 
  [value index] = max(error(q_Neighbors));
  f = q_Neighbors(index); 
    
% Add the new node half-way between nodes q and f: 
   nodes = [nodes .5*(nodes(:,q) + nodes(:,f))];
   
% Remove the original edge between q and f.
   edges(q,f) = 0;
   edges(f,q) = 0;
   ages(q,f) = NaN;
   ages(f,q) = NaN;
   
   NumOfNodes = NumOfNodes + 1;
   r = NumOfNodes;
   
   % Insert edges connecting the new unit r with units q anf f. 
   edges = [edges  zeros(NumOfNodes-1,1)];
   edges = [edges; zeros(1,NumOfNodes)];
     
   edges(q,r) = 1;
   edges(r,q) = 1;
   edges(f,r) = 1;
   edges(r,f) = 1;
  
   ages = [ages  NaN*ones(NumOfNodes-1,1)];
   ages = [ages; NaN*ones(1,NumOfNodes)];
   
   ages(q,r) = 0;
   ages(r,q) = 0;
   ages(f,r) = 0;
   ages(r,f) = 0;
   
   error(q) = alpha*error(q);
   error(f) = alpha*error(f);
   
   error = [error error(q)];

% MEX-code Generation:  
   
% mexcfg = coder.config('mex');
% mexcfg.DynamicMemoryAllocation = 'AllVariableSizeArrays'; 
% codegen -config mexcfg addNewNeuron.m -args {coder.typeof(nodes,[Inf Inf]), coder.typeof(edges,[Inf Inf]), coder.typeof(ages,[Inf Inf]), coder.typeof(error,[1 Inf]), double(0)}
