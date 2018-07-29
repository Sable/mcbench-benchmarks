%mmcfindp0(lambda,mu,c)
%   This function finds the probability all machines are working
%   for an M/M/c queueing system.

function out = mmcfindp0(lambda,mu,c)

p = lambda/(mu*c);
pc = lambda/mu;

firstsum = 0;

for i = 0:c-1
    term = (pc^i)/(factorial(i));
    firstsum = firstsum + term;
end

total = firstsum + ((pc)^c)/(factorial(c)*(1-p));
p0 = total^-1;

out = p0;
