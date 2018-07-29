function [kk,ff]=constraints(kk,ff,bcdof,bcval)

%----------------------------------------------------------
%  Purpose:
%     Apply constraints to matrix equation [K]{x}={F}
%
%  Synopsis:
%     [kk,ff]=constraints(kk,ff,bcdof,bcval)
%
%  Variable Description:
%     kk - system matrix before applying constraints 
%     ff - system vector before applying constraints
%     bcdof - a vector containging constrained d.o.f
%     bcval - a vector containing contained value 
%-----------------------------------------------------------
 
 n=length(bcdof);
 sdof=size(kk);

 for i=1:n
    c=bcdof(i);
    for j=1:sdof
       kk(c,j)=0;
    end

    kk(c,c)=1;
    ff(c)=bcval(i);
 end

