function [kk,mm]=constraints(kk,mm,bcdof)

%----------------------------------------------------------------------
%  Purpose:
%     Apply constraints to eigenvalue matrix equation 
%     [kk]{x}=lamda[mm]{x}
%
%  Synopsis:
%     [kk,mm]=feaplycs(kk,mm,bcdof)
%
%  Variable Description:
%     kk - system stiffness matrix before applying constraints 
%     mm - system mass matrix before applying constraints
%     bcdof - a vector containging constrained d.o.f
%---------------------------------------------------------------------
 
 n=length(bcdof);
 sdof=size(kk);
 
 for i=1:n
    c=bcdof(i);
    for j=1:sdof
       kk(c,j)=0;
       kk(j,c)=0;
       mm(c,j)=0;
       mm(j,c)=0;
    end
    kk(c,c)=1;
    mm(c,c)=1;
 end

