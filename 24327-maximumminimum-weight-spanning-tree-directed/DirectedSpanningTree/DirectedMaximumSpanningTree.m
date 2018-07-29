function [ TreeMatric,Cost ] = DirectedMaximumSpanningTree( OriginalCostMatric,Root )
% MST on a directed graph
% Chu-Liu/Edmonds Algorithm:
%1 Discard the arcs entering the root if any; For each node other than the root, select the entering arc with the highest cost; Let the selected n-1 arcs be the set S. 
%  If no cycle is formed, G( N,S ) is a MST. Otherwise, continue. 
%2 For each cycle formed, contract the nodes in the cycle into a pseudo-node (k), and modify the cost of each arc which enters a node (j) in the cycle from some node (i)
%  outside the cycle according to the following equation.  c(i,k)=c(i,j)-(c(x(j),j)-min_{j}(c(x(j),j)) where c(x(j),j) is the cost of the arc in the cycle which enters j. 
%3 For each pseudo-node, select the entering arc which has the smallest modified cost; Replace the arc which enters the same real node in S by the new selected arc. 
%4 Go to step 2 with the contracted graph.

% This code is written by Lowell Guangdi, Email: lowellli121@gmail.com
Dim = size( OriginalCostMatric,2 );
for p = 1:Dim, OriginalCostMatric( p,p ) = 0;end

Min = min(min(OriginalCostMatric));
OriginalCostMatric = OriginalCostMatric - Min;

CostMatric = OriginalCostMatric;
CostMatric( :,Root )= zeros( Dim,1 ); 
while 1
     TreeMatric = CostMatric;
     % select out the maximal weights of arcs upon each node.   
     for p = 1 : Dim
         if p ~= Root
            [ LocalMax,Index ] = max( TreeMatric( :,p ) ); 
            TreeMatric( :,p ) = zeros( Dim,1 );
            TreeMatric( Index,p ) = LocalMax;
         end   
     end  
     % test the existence of cycle
     [ CNumber, Component ] = conncomp( biograph( TreeMatric ),'Weak', true );
     if CNumber == 1,break; end
     % Cycle exists
     RootCluster = Component( Root );
     RootSharedNode = find( Component == RootCluster );
     if RootCluster == 1
        CaredCluster = 2;
     elseif RootCluster > 1
        CaredCluster = 1;
     end
     % change the weight here
     ClusterNode = find( Component == CaredCluster );
     CostMatric = SearchCycleNode(ClusterNode,TreeMatric, CostMatric,OriginalCostMatric,RootSharedNode); 
end
TreeMatric = CostMatric;
Cost = sum(sum( TreeMatric ));
end
