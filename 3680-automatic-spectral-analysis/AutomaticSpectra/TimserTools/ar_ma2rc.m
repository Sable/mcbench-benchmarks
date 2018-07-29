function [rc, varp] = ar_ma2rc(ar,ma,n_obs)

%[Used internally by KLDiscrepancy, KLIndex, KLIndex_hat]

%S. de Waele, March 2003.

if ma == 1,
    [dummy, rc] = ar2arset(ar);
    if length(rc) > n_obs;
        rc = rc(1:n_obs);
    end
else
    cor = arma2cor(ar,ma,n_obs-1);
    [dummy,rc] = cov2arset(cor);
end
rc(1) = 1;