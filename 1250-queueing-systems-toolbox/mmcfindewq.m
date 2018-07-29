%mmcfindewq(lambda,mu,c)
%   This function finds the average waiting time
%   for an M/M/c queueing system.

function out = mmcfindewq(lambda,mu,c)

lq = mmcfindlq(lambda,mu,c);
ewq = lq/lambda;

out = ewq;