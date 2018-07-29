function [kk,ff]=assemble(kk,ff,k,f,index)
%----------------------------------------------------------
%  Purpose:
%     Assembly of element stiffness matrix into the system matrix &
%     Assembly of element force vector into the system vector
%
%  Synopsis:
%     [kk,ff]=assemble(kk,ff,k,f,index)
%
%  Variable Description:
%     kk - system stiffnes matrix
%     ff - system force vector
%     k  - element stiffness matrix
%     f  - element force vector
%     index - d.o.f. vector associated with an element
%-----------------------------------------------------------

 
 edof = length(index);
 for i=1:edof
   ii=index(i);
     ff(ii)=ff(ii)+f(i);
     for j=1:edof
       jj=index(j);
         kk(ii,jj)=kk(ii,jj)+k(i,j);
     end
 end

