function [nodes, edges] = bnMsgPassCreate(M, values, CPT)
% BNMSGPASSCREATE helper function for lungbayesdemo

% Reference: Neapolitan R., "Learning Bayesian Networks", Pearson Prentice Hall,
% Upper Saddle River, New Jersey, 2004.

%=== create a dummy structure for nodes
dummy1.id = [];      
dummy1.values = []; 
dummy1.parents = []; 
dummy1.children = [];
dummy1.peye = [];    
dummy1.lambda = [];
dummy1.CPT = [];     
dummy1.P = [];

%=== create a dummy structure for edges
dummy2.peyeX = [];
dummy2.lambdaX = [];

%=== create nodes
N = size(M,1); % number of nodes
nodes = repmat(dummy1, N, 1);

%=== create edges
edges = repmat(dummy2, size(M));

%=== populate nodes with data
for i = 1:N
    nodes(i).id = i;
    nodes(i).parents = find(M(:,i));
    nodes(i).children = find(M(i,:));
    nodes(i).CPT = CPT{i};
    nodes(i).values = values{i};
end




 
