function [stiffness]=assemble(stiffness,k,index)
%----------------------------------------------------------
%  Purpose:
%     Assembly of element matrices into the system matrix
%
%  Synopsis:
%     [stiffness]=assemble(stiffness,k,index)
%
%  Variable Description:
%     stiffness - system matrix
%     k  - element matri
%     index - d.o.f. vector associated with an element
%-----------------------------------------------------------

 
 edof = length(index);
 for i=1:edof
   ii=index(i);
     for j=1:edof
       jj=index(j);
         stiffness(ii,jj)=stiffness(ii,jj)+k(i,j);
     end
 end

