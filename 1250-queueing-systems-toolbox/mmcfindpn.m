%mmcfindpn(lambda,mu,c,n)
%   This function finds the probability there are n customers
%   in the system for an M/M/c queueing system.

function out = mmcfindpn(lambda,mu,c,n)

p = lambda/(mu*c);
pc = lambda/mu;
p0 = mmcfindp0(lambda,mu,c);

if n == 0
    pn = p0;
end

if n >= 1
    if n < c
        pn = (pc^n)/factorial(n)*p0;
    end
end

if n >= c
    pn = (c^c)/factorial(c)*p0*p^n;
end

out = pn;
