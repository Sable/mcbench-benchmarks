
% LegendrePoly.m by David Terr, Raytheon, 5-10-04

% Given nonnegative integer n, compute the 
% Legendre polynomial P_n. Return the result as a vector whose mth
% element is the coefficient of x^(n+1-m).
% polyval(LegendrePoly(n),x) evaluates P_n(x).


function pk = LegendrePoly(n)

if n==0 
    pk = 1;
elseif n==1
    pk = [1 0]';
else
    
    pkm2 = zeros(n+1,1);
    pkm2(n+1) = 1;
    pkm1 = zeros(n+1,1);
    pkm1(n) = 1;

    for k=2:n
        
        pk = zeros(n+1,1);

        for e=n-k+1:2:n
            pk(e) = (2*k-1)*pkm1(e+1) + (1-k)*pkm2(e);
        end
        
        pk(n+1) = pk(n+1) + (1-k)*pkm2(n+1);
        pk = pk/k;
        
        if k<n
            pkm2 = pkm1;
            pkm1 = pk;
        end
        
    end
    
end