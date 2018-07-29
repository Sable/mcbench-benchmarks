%mmcfindls(lambda,mu,c)
%   This function finds the average system size
%   for an M/M/c queueing system.

function out = mmcfindls(lambda,mu,c)

pc = lambda/mu;
lq = mmcfindlq(lambda,mu,c);

ls = lq + pc;

out = ls;