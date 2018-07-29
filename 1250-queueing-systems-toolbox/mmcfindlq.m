%mmcfindlq(lambda,mu,c)
%   This function finds the average queue size
%   for an M/M/c queueing system.

function out = mmcfindlq(lambda,mu,c)

p = lambda/(mu*c);
pc = lambda/mu;
p0 = mmcfindp0(lambda,mu,c);

lq = ((pc)^c)/factorial(c)*p0*p/((1-p)^2);

out = lq;