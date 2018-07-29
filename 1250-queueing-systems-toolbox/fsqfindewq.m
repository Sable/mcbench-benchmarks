%fsqfindewq(lambda,mu,c,m)
%   This function finds the average waiting time in the queue
%   (ewq) for a machine repair problem (finite source queue)

function out = fsqfindewq(lambda,mu,c,m)

ld = fsqfindld(lambda,mu,c,m);
lu = fsqfindlu(lambda,mu,c,m);

ewq = ld/(lambda*lu);

out = ewq;