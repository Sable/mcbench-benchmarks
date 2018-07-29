
% cfrac.m by David Terr, Raytheon Inc., 5-20-04

% Modified on 7-29-04 to include rational convergents.

% cfrac(x,n) returns a 3x3 matrix whose first column consists of the first n continued fraction coefficients of a given
% nonnegative real number x and whose second and third columns consist of
% the numerators and denominators of the first n rational convergents of x
% respectively.

% Warning: If n is set too large, fewer coefficients may be returned and
% the last coefficient may be incorrect, due to rounding errors.

function c = cfrac(x,n)

c = zeros(n,3);
t = x;
k = 1;
p1 = 1;
p2 = 0;
q1 = 0;
q2 = 1;
done = 0;

while k<=n && ~done
    a = floor(t);
    c(k,1) = a;
    r = t - a;
    c(k,2) = r;
    p = a*p1 + p2;
    q = a*q1 + q2;
    c(k,2) = p;
    c(k,3) = q;
    
    if r==0 || x == p/q;
        done = true;
    else
        t = 1/r;
        k = k + 1;
        p2 = p1;
        q2 = q1;
        p1 = p;
        q1 = q;
    end
end

c = c(1:min(k,n),1:3);