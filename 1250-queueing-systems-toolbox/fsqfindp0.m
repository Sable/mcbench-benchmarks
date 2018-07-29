%fsqfindp0(lambda,mu,c,m)
%   This function finds the probability all machines are working
%   for a machine repair problem (finite source queue)

function out = fsqfindp0(lambda,mu,c,m)

firstsum = 0;
secondsum = 0;

for i = 0:c-1
    term = nchoosek(m,i)*(lambda/mu).^i;
    firstsum = firstsum + term;
end

for i = c:m
    term = nchoosek(m,i)*(lambda/mu).^i*factorial(i)./(factorial(c)*c.^(i-c));
    secondsum = secondsum + term;
end

total = firstsum + secondsum;
p0 = total.^(-1);

out = p0;