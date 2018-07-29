%fsqfindpn(lambda,mu,c,m,n)
%   This function finds the probability there are n machines down
%   (in the system) for a machine repair problem (finite source queue).

function out = fsqfindpn(lambda,mu,c,m,n)

p0 = fsqfindp0(lambda,mu,c,m);

if n == 0
    pn = p0;
end

if n >= 1
    if n < c
        pn = nchoosek(m,n)*(lambda/mu)^n*p0;
    end
end

if n >= c
    if n <= m
        pn = nchoosek(m,n)*(lambda/mu)^n*p0*factorial(n)/(factorial(c)*c^(n-c));
    end
end

if n > m
    pn = 0;
end

out = pn;