function [index]=elementdof(node,nnel,ndof)
%----------------------------------------------------------
%  Purpose:
%     Compute system dofs associated with each element 
%
%  Synopsis:
%     [index]=elementdof(node,nnel,ndof)
%
%  Variable Description:
%     index - system dof vector associated with element "iel"
%     iel - element number whose system dofs are to be determined
%     node - nodes associated with the element "iel"
%     nnel - number of nodes per element
%     ndof - number of dofs per node 
%-----------------------------------------------------------
 
 
   k=0;
   for i=1:nnel
     start = (node(i)-1)*ndof;
       for j=1:ndof
         k=k+1;
         index(k)=start+j;
       end
   end

 
