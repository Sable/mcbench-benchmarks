%
% lellippi(phi, k, errtol)
%
% Inputs:
%
%   phi     Input angle vector size 1 or 1xN.
%   k       Input parameter vector size 1 or 1xN.
%   n       Input parameter vector size 1 or 1xN.
%   errtol  Error tolerance for Carlson's algorithms.
%
% Matlab function to compute Legendre's (incomplete) elliptic integral 
% Pi(phi, k, n).  Uses a vectorized implementation of Carlson's Duplication Algorithms 
% for symmetric elliptic integrals as found in "Computing Elliptic 
% Integrals by Duplication," by B. C. Carlson, Numer. Math. 33, 1-16 (1979)
% and also found in ACM TOMS Algorithm 577.  Section 4 in the paper cited
% here describes how to convert between the symmetric elliptic integrals
% and Legendre's elliptic integrals.
%
% Returns NaN's for any argument values outside input range.
%

function f = lellippi(phi, k, n, errtol)
% Argument checking for vectorization:
lphi = length(phi);
lk = length(k);
ln = length(n);
errflag = logical(0);
if ( ~ ((lphi==lk) & (lphi==ln) & (lk==ln)) )
    if ( (lk==1) & (ln==1) )
        kvec = k * ones(1,lphi);
        nvec = n * ones(1,lphi);
        phivec = phi;
    elseif ( (lphi==1) & (ln==1) ) 
        phivec = phi * ones(1,lk);
        nvec = n * ones(1,lk);
        kvec = k;
    elseif ( (lphi==lk) & (ln==1) )
        nvec = n * ones(1,lphi);
        kvec = k;
        phivec = phi;
    elseif ( (lphi==1) & (lk==1) )
        phivec = phi * ones(1,ln);
        kvec = k * ones(1,lk);
        nvec = n;
    elseif ( (lphi==ln) & (lk==1) )
        kvec = k * ones(1,lphi);
        phivec = phi;
        nvec = n;
    elseif ( (lk==ln) & (lphi==1) )
        phivec = phi * ones(1,lk);
        kvec = k;
        nvec = n
    else
        disp('Incompatible input vector dimensions in lellipf!');
        errflag = logical(1);
    end
else
    phivec = phi;
    kvec = k;
    nvec = n;
end
if (~errflag)
    snphi = sin(phivec);
    csphi = cos(phivec);
    snphi2 = snphi.^2;
    csphi2 = csphi.^2;
    k2 = kvec.^2;
    y = 1.0 - k2.*snphi2;
    p = 1.0 + nvec .* snphi2;
    onesvec = ones(1,length(phivec));
    f = snphi .* rf(csphi2,  y, onesvec, errtol) - ...
        nvec .* snphi .* snphi2 .* rj(csphi2, y, onesvec, p, errtol) / 3.0;
else
    f = NaN;
end