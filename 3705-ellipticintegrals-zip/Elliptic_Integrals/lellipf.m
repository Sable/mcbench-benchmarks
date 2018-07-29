
%
% lellipf(phi, k, errtol)
%
% Inputs:
%
%   phi     Input angle vector size 1 or 1xN.
%   k       Input parameter vector size 1 or 1xN.
%   errtol  Error tolerance for Carlson's algorithms.
%
% Matlab function to compute Legendre's (incomplete) elliptic integral 
% F(phi, k).  Uses a vectorized implementation of Carlson's Duplication Algorithms 
% for symmetric elliptic integrals as found in "Computing Elliptic 
% Integrals by Duplication," by B. C. Carlson, Numer. Math. 33, 1-16 (1979)
% and also found in ACM TOMS Algorithm 577.  Section 4 in the paper cited
% here describes how to convert between the symmetric elliptic integrals
% and Legendre's elliptic integrals.
%
% Returns NaN's for any argument values outside input range.
%

function f = lellipf(phi, k, errtol)

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

if ~errflag
    snphi = sin(phivec);
    csphi = cos(phivec);
    csphi2 = csphi .* csphi;
    onesvec = ones(1,length(phivec));
    y = onesvec - kvec.*kvec .* snphi.*snphi;
    f = snphi .* rf(csphi2,  y, onesvec, errtol);
else
    f = NaN;
end