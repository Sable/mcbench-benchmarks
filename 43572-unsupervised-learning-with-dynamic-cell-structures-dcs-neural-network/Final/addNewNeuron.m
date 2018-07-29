function [nodes error C] = addNewNeuron(nodes,error,C)
% This function adds a new neural unit at the existing DCS structure
% whenever the dcstrain.m routine calls it.

   NumOfNodes = size(nodes,2);
   
   % Find the neuron l with maximum error:
    [max_error  l] = max(error);
        
    % Find l-Neighborhood
     l_Neighbors = find(C(:,l)~=0).';    
 
   % Find the neighbor n with the largest accumulated error. 
     [value index] = max(error(l_Neighbors));
     n = l_Neighbors(index); 
   
   gamma = error(n)/(error(n)+error(l));
   nodes = [nodes nodes(:,l)+gamma*(nodes(:,n)-nodes(:,l))];
   
   %Error Updates.
   derror_l = .5*(1-gamma)*error(l);
   derror_n = .5*gamma*error(n);
   
   % Remove the original edge between l and n.
   C(n,l) = 0;
   C(l,n) = 0;
   
   NumOfNodes = NumOfNodes + 1;
   r = NumOfNodes;
   
   % Insert edges connecting the new unit r with units l anf n. 
   C = [C  zeros(NumOfNodes-1,1)];
   C = [C; zeros(1,NumOfNodes)];
     
   C(l,r) = 1;
   C(r,l) = 1;
   C(n,r) = 1;
   C(r,n) = 1;
  
   % Update the errors after the insertion of the new unit.
   error(n) = error(n) - derror_n;
    error(l) = error(l) - derror_l;
   
   error = [error derror_l+derror_n];

  
