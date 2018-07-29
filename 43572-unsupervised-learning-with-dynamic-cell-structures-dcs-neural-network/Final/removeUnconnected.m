function [nodes, error, C] = removeUnconnected(nodes,error,C)
% This function removes unconnected (dead) nodes from the DCS structure.

NumOfNodes = size(nodes,2);

i = 1;
while i<=NumOfNodes
          if (any(C(i,:))==0)  
                            
              C = [C(1:i-1,:); C(i+1:NumOfNodes,:);];
              C = [C(:,1:i-1)  C(:,i+1:NumOfNodes);];
       
              nodes = [nodes(:,1:i-1) nodes(:,i+1:NumOfNodes);];
                 error = [error(1,1:i-1) error(1,i+1:NumOfNodes);];
        
               NumOfNodes = NumOfNodes - 1;
               i = i-1;
          end
           i = i+1;
 end
   