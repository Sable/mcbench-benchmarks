function [ TreeMatric,Cost ] =  DirectedMinimalSpanningTree( OriginalCostMatric,Root )

    MaxTree =  DirectedMaximumSpanningTree( -OriginalCostMatric,Root );
    TreeMatric = -MaxTree;
    Cost = sum(sum(TreeMatric));
    
end