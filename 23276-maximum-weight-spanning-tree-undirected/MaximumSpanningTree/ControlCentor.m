%ControlCentor

% CostMatrix can be considered as the cost matrix
CostMatrix = rand(30);

% Tree is the matrix saving the tree, and Cost is summation of all cost
% upon arcs.
[ Tree,Cost ] =  UndirectedMaximumSpanningTree ( CostMatrix )
h1 = view(biograph( Tree ))
