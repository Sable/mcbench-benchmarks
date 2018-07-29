function Path = TestPathInGraph(DAG,Start,End)
% Input:DAG is the graph, p the start point, q the end point.
% Output:if there is a path from p to q, return Path = 1,otherwise Path = 0;  

% test the cycle by DFS algorithm
Path = 0;
Visited = zeros( 1,size( DAG,1 ) );
[ List,Visited ] = SearchPath( DAG,Start,[],Visited );

    while isempty( List ) == 0
         %Node = List(1)
         Descendant = List(1);
         if Descendant == End 
             Path = 1;
             break;
         end
         List( 1 )=[];
         if Visited( Descendant ) ==0
            [List,Visited] = SearchPath(DAG,Descendant,List,Visited); 
         end
    end
end

function [ List,Visited ] = SearchPath( DAG,Start,L,V )
 V( Start ) = 1;
 Visited=V;
 Descendant = find( DAG(Start,:) ~= 0 );
 List = [L Descendant];
end