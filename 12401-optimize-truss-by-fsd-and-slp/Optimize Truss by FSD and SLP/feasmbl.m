function [kk]=feasmbl(kk,k,index)
%----------------------------------------------------------
%  Purpose:
%     Assembly of element matrices into the system matrix
%
%  Synopsis:
%     [kk]=feasmbl(kk,k,index)
%
%  Variable Description:
%     kk - system matrix
%     k  - element matri
%     index - d.o.f. vector associated with an element
%-----------------------------------------------------------
% syms X1 X2 X3 
edof=length(index);
for i=1:edof
    ii=index(i);
    for j=1:edof
        jj=index(j);
        kk(ii,jj)=kk(ii,jj)+k(i,j);
    end
end