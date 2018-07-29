function [kld, set_kld]= KLDiscrepancy(ar_est,ma_est,varx_est,ar,ma,varx,n_obs)

%KLDiscrepancy Kullback-Leibler discrepancy.
%   kld = KLDiscrepancy(a_est,b_est,varx_est,a,b,varx,nobs) is the exact Kullbach-Leibler
%   Discrepancy between two time series models for nobs observations.
%   The estimated proces a_est, b_est, var_est and the true process a,b,varx are assumed
%   to be normally distributed.
%
%   Possible second output argument: set of KLD's of AR models of increasing autoregressive
%   model order:
%   [kld set_kld] = KLDiscrepancy(a_est,b_est,varx_est,a,b,varx,nobs)

%S. de Waele, February 2003.

rc = ar_ma2rc(ar,ma,n_obs);
ar_order = length(rc)-1;
rc_est = ar_ma2rc(ar_est,ma_est,n_obs);
ar_est_order = length(rc_est)-1;

%KLIauto: kli_ff
varp = varx*[1 cumprod(1-rc(2:end).^2)];
kli_ff = sum(log(varp)) + (n_obs-ar_order-1)*log(varp(end)) + n_obs;
if ar_est_order > ar_order,
    varp = [varp varp(end)*ones(1,ar_est_order-ar_order)];
end

%Kullback-Leiber index of the estimated process
%with respect to the true process: kli_fef.
varp_est = varx_est*[1 cumprod(1-rc_est(2:end).^2)];

%Prediction errors (vareta)
rc_est(1) = 1; %Must be exactly 1 for rc2arset function
set_ar_est = rc2arset(rc_est,0:ar_est_order);
cov = varx*arma2cor(ar,ma,ar_est_order);
covs = [cov(end:-1:2) cov];
for L = 0:ar_est_order,
    par_est = set_ar_est{1+L};
    %covt = covs(1+(ar_est_order-L):end-(ar_est_order-L));
    sh = ar_est_order+L+1;
    vareta(L+1) = convol(par_est,convol(covs,par_est(end:-1:1)),sh,sh);
end

L = 0:ar_est_order;    
set_kli_fef = cumsum(log(varp_est)) + cumsum(vareta./varp_est) ...
    + (n_obs-L-1).*(log(varp_est) + vareta./varp_est);

set_kld = set_kli_fef - kli_ff;
kld = set_kld(end);

%---------------------------------------------------------
function [rc, varp] = ar_ma2rc(ar,ma,n_obs)
if ma == 1,
    [dummy, rc] = ar2arset(ar);
    if length(rc) > n_obs;
        rc = rc(1:n_obs);
    end
else
    cor = arma2cor(ar,ma,n_obs-1);
    [dummy,rc] = cov2arset(cor);
end
