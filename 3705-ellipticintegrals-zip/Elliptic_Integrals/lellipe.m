%
% lellipe(phi, k, errtol)
%
% Inputs:
%
%   phi     Input angle vector size 1xN.
%   k       Input parameter vector size 1 or 1xN.
%   errtol  Error tolerance for Carlson's algorithms.
%
% Matlab function to compute Legendre's (incomplete) elliptic integral 
% E(phi, k).  Uses a vectorized implementation of Carlson's Duplication Algorithms 
% for symmetric elliptic integrals as found in "Computing Elliptic 
% Integrals by Duplication," by B. C. Carlson, Numer. Math. 33, 1-16 (1979)
% and also found in ACM TOMS Algorithm 577.  Section 4 in the paper cited
% here describes how to convert between the symmetric elliptic integrals
% and Legendre's elliptic integrals.
%
% Returns NaN's for any argument values outside input range.
%

function f = lellipe(phi, k, errtol)

% Argument checking for vectorization:
lphi = length(phi);
lk = length(k);
errflag = logical(0);
if (lphi ~= lk)
    if (lphi==1)
        phivec = phi * ones(1,lk);
        kvec = k;
    elseif (lk==1)
        kvec = k * ones(1,lphi);
        phivec = phi;
    else
        disp('Incompatible input vector dimensions in lellipf!');
        errflag = logical(1);
    end
else
    phivec = phi;
    kvec = k;
end

if (~errflag)
    snphi = sin(phivec);
    csphi = cos(phivec);
    snphi2 = snphi.^2;
    csphi2 = csphi.^2;
    k2 = kvec.^2;
    y = 1.0 - k2.*snphi2;
    onesvec = ones(1,length(phivec));
    f = snphi .* rf(csphi2,  y, onesvec, errtol) - ...
        k2 .* snphi .* snphi2 .* rd(csphi2, y, onesvec, errtol)/3.0;
else
    f = NaN;
end