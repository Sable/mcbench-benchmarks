%fsqfindld(lambda,mu,c,m)
%   This function finds the number of machines down (ld) 
%   for a machine repair problem (finite source queue).

function out = fsqfindld(lambda,mu,c,m)

lu = fsqfindlu(lambda,mu,c,m);
ld = m - lu;

out = ld;