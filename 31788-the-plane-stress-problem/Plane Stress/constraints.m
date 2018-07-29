function [stiffness,force]=constraints(stiffness,force,bcdof,bcval)

%----------------------------------------------------------
%  Purpose:
%     Apply constraints to matrix equation [kk]{x}={ff}
%
%  Synopsis:
%     [stiffness,force]=constraints(kk,ff,bcdof,bcval)
%
%  Variable Description:
%     stiffness - system matrix before applying constraints 
%     force - system vector before applying constraints
%     bcdof - a vector containging constrained d.o.f
%     bcval - a vector containing contained value 
%
%     For example, there are constraints at d.o.f=2 and 10
%     and their constrained values are 0.0 and 2.5, 
%     respectively.  Then, bcdof(1)=2 and bcdof(2)=10; and
%     bcval(1)=1.0 and bcval(2)=2.5.
%-----------------------------------------------------------
 
 n=length(bcdof);
 sdof=size(stiffness);

 for i=1:n
    c=bcdof(i);
    for j=1:sdof
       stiffness(c,j)=0;
    end

    stiffness(c,c)=1;
    force(c)=bcval(i);
 end

