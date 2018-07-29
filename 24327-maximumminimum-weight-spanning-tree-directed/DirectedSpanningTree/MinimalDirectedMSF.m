function [ CostMatric,Cost ] =  MinimalDirectedMSF( CostMatric )
% MST on a directed graph
% Chu-Liu/Edmonds Algorithm:
%1 Discard the arcs entering the root if any; For each node other than the root, select the entering arc with the highest cost; Let the selected n-1 arcs be the set S. 
%  If no cycle formed, G( N,S ) is a MST. Otherwise, continue. 
%2 For each cycle formed, contract the nodes in the cycle into a pseudo-node (k), and modify the cost of each arc which enters a node (j) in the cycle from some node (i)
%  outside the cycle according to the following equation.  c(i,k)=c(i,j)-(c(x(j),j)-min_{j}(c(x(j),j)) where c(x(j),j) is the cost of the arc in the cycle which enters j. 
%3 For each pseudo-node, select the entering arc which has the smallest modified cost; Replace the arc which enters the same real node in S by the new selected arc. 
%4 Go to step 2 with the contracted graph.

% Pay attention, we extend the Chu-Liu algorithm into considering
% forest.And we consider of discarding the premise of giving the root here.
% CostMatric must be symmetric

  [ Number, Component ] = conncomp(  biograph( CostMatric ),'Weak', true );
  for k = 1:Number      
      LocalNodes = find( Component == k );
      Dim = size( LocalNodes,2 );
      if Dim == 1
         continue
      elseif Dim == 2
          if CostMatric( LocalNodes(1),LocalNodes(2) ) > CostMatric( LocalNodes(2),LocalNodes(1) ) 
              CostMatric( LocalNodes(2),LocalNodes(1) ) = 0;
          else
              CostMatric( LocalNodes(1),LocalNodes(2) ) = 0;
          end
      elseif Dim > 2          
      ComponentCost = CostMatric( LocalNodes,LocalNodes );
      MinTree = zeros( Dim ); MinTreeCost = Inf;      
      for m = 1:Dim
          Root = m;
          LocalCostMatric = ComponentCost;
          LocalCostMatric( :,Root ) = zeros( Dim,1 );
          [ LocalTree,LocalCostTree ] =  DirectedMinimalSpanningTree( LocalCostMatric,Root );
          if MinTreeCost > LocalCostTree
             MinTree = LocalTree;
             MinTreeCost = LocalCostTree ;
          end
      end
      CostMatric( LocalNodes,LocalNodes ) = MinTree;   
      end
   end
   Cost = sum( sum( CostMatric ));
end
