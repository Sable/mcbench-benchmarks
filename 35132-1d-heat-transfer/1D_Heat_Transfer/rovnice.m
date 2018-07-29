function [c,f,s]=rovnice(x,t,u,DuDx)
global a
% evaluates the quantities defining the 
%     differential equation. The input arguments are scalars X and T and 
%     vectors U and DUDX that approximate the solution and its partial 
%     derivative with respect to x, respectively. PDEFUN returns column 
%     vectors: C (containing the diagonal of the matrix c(x,t,u,Dx/Du)), 
%     F, and S (representing the flux and source term, respectively).
c=1;
f=a*DuDx;
s=0;