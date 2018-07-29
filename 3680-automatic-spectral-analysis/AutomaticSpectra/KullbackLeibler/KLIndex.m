function [kli, set_kli]= KLIndex(ar_est,ma_est,varx_est,ar,ma,varx,n_obs)

%KLIndex Kullback-Leibler index.
%   kli = KLIndex(a_est,b_est,varx_est,a,b,varx,nobs) is the exact Kullbach-Leibler
%   Index between two time series models for nobs observations.
%   The estimated proces a_est, b_est,var_est and the true process a,b,varx are assumed
%   to be normally distributed.
%
%   Possible second output argument: set of KLI's of AR models of increasing autoregressive
%   model order:
%   [kli set_kli] = KLIndex(a_est,b_est,varx_est,a,b,varx,nobs)

%S. de Waele, Februari 2003.

rc = ar_ma2rc(ar,ma,n_obs);
ar_order = length(rc)-1;
rc_est = ar_ma2rc(ar_est,ma_est,n_obs);
ar_est_order = length(rc_est)-1;

%Kullback-Leiber index of the estimated process
%with respect to the true process: kli_fef.
varp_est = varx_est*[1 cumprod(1-rc_est(2:end).^2)];

%Prediction errors (vareta)
set_ar_est = rc2arset(rc_est,0:ar_est_order);
cov = varx*arma2cor(ar,ma,ar_est_order);
covs = [cov(end:-1:2) cov];
for L = 0:ar_est_order,
    par_est = set_ar_est{1+L};
    sh = ar_est_order+L+1;
    vareta(L+1) = convol(par_est,convol(covs,par_est(end:-1:1)),sh,sh);
end

L = 0:ar_est_order;    
set_kli_fef = cumsum(log(varp_est)) + cumsum(vareta./varp_est) ...
    + (n_obs-L-1).*(log(varp_est) + vareta./varp_est);

set_kli = set_kli_fef;
kli = set_kli(end);