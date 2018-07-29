%fsqfindlu(lambda,mu,c,m)
%   This function finds the average number of machines up and working (lu)
%   for a machine repair problem (finite source queue)

function out = fsqfindlu(lambda,mu,c,m)

ldr = fsqfindldr(lambda,mu,c,m);
lu = (mu/lambda)*ldr;

out = lu;