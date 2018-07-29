%ControlCenter

% compile the mex programming function.
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

% As for other provided algorithms, you can look at the code , and change
% the part in the similar way.....cheers!!!




