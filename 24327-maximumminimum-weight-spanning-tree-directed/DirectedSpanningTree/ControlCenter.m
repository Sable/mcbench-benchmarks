%ControlCenter
mex SearchCycleNode.c

n=30; % The number of nodes in the tree

CostMatric = rand( n );  % randomly generating a cost matrix
for p=1:n
    CostMatric( p,p ) = 0;
end

% 1. search maximum directed spanning tree by unsymmetrical cost matrix "CostMatric", with specified root node "Root".

Root = 3;    % Root of the tree is predefined ahead .
[MaxTree1,MaxCost1] =  DirectedMaximumSpanningTree( CostMatric,Root )
h = view(biograph( MaxTree1 ));

% 2. % 1. search maximum directed spanning tree by unsymmetrical cost matrix "CostMatric", with no specified root node "Root".

[MaxTree2,MaxCost2] =  MaximalDirectedMSF( CostMatric )
h = view(biograph( MaxTree2 ));

% 3. search minimum directed spanning tree by unsymmetrical cost matrix "CostMatric", with specified root node "Root".

Root = 3;    % Root of the tree is predefined ahead .
[MaxTree3,MaxCost3] =  DirectedMinimalSpanningTree( CostMatric,Root )
h = view(biograph( MaxTree3 ));

% 2. % 1. search minimum directed spanning tree by unsymmetrical cost matrix "CostMatric", with no specified root node "Root".

[MaxTree4,MaxCost4] =  MinimalDirectedMSF( CostMatric )
h = view(biograph( MaxTree4 ));





