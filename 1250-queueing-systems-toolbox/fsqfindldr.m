%fsqfindldr(lambda,mu,c,m)
%   This function finds the average number of machines being repaired (ldr)
%   for a machine repair problem (finite source queue)

function out = fsqfindldr(lambda,mu,c,m)

p0 = fsqfindp0(lambda,mu,c,m);
firstsum = 0;

for i = 0:c-1
    term = (c-i)*nchoosek(m,i)*(lambda/mu)^i*p0;
    firstsum = firstsum + term;
end

ldr = c - firstsum;

out = ldr;