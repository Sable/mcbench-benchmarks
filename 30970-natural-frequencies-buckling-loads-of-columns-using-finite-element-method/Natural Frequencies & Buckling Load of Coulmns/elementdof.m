function [index]=eldof(iel,nnel,ndof)
%----------------------------------------------------------
%  Purpose:
%     Compute system dofs associated with each element in one-
%     dimensional problem
%
%  Synopsis:
%     [index]=eldof(iel,nnel,ndof)
%
%  Variable Description:
%     index - system dof vector associated with element "iel"
%     iel - element number whose system dofs are to be determined
%     nnel - number of nodes per element
%     ndof - number of dofs per node 

%-----------------------------------------------------------

 
 edof = nnel*ndof;
 start = (iel-1)*(nnel-1)*ndof;

   for i=1:edof
      index(i)=start+i;
   end

 
