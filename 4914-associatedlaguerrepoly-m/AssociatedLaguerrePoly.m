
% AssociatedLaguerrePoly.m by David Terr, Raytheon, 5-11-04

% Given nonnegative integers n and k with k<=n, compute the associated
% Laguerre polynomial L{n,k}. Return the result as a vector whose mth
% element is the coefficient of x^(n+1-m).
% polyval(AssociatedLaguerrePoly(n,k),x) evaluates L{n,k}(x).

% Note: This program requires downloading binomial.m first.


function Lnk = AssociatedLaguerrePoly(n,k)

if k==0
    Lnk = LaguerrePoly(n);
else
    Lnk = zeros(n+1,1);
    
    for m=0:n
        Lnk(n+1-m) = (-1)^m * binomial(k+n,n-m) / factorial(m);
    end
    
end