% lmom by Kobus N. Bekker, 14-09-2004
% Based on calculation of probability weighted moments and the coefficient
% of the shifted Legendre polynomial.

% Given nonnegative integer nL, compute the 
% nL l-moments for given data vector X. 
% Return the l-moments as vector L.

function [L] = lmom(X,nL)

[rows cols] = size(X);
if cols == 1 X = X'; end
n = length(X);
X = sort(X);
b = zeros(1,nL-1);
l = zeros(1,nL-1);
b0 = mean(X);

for r = 1:nL-1
    Num = prod(repmat(r+1:n,r,1)-repmat([1:r]',1,n-r),1);
    Den = prod(repmat(n,1,r) - [1:r]);
    b(r) = 1/n * sum( Num/Den .* X(r+1:n) );
end

tB = [b0 b]';
B = tB(length(tB):-1:1);

for i = 1:nL-1
    Spc = zeros(length(B)-(i+1),1);
    Coeff = [Spc ; LegendreShiftPoly(i)];
    l(i) = sum((Coeff.*B),1);
end

L = [b0 l];

