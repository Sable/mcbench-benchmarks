function klihs = KLIndex_hat(ys,ar,ma,vary)

%KLINDEX_HAT Estimate of the Kullback-Leibler index
%   klih = KLIndex_hat(y,a,b,vary)
%   is an estimate of the Kullback-Leibler index of the ARMA-model with parameters
%   a and b and variance v. The model is assumed to be a normal distribution.
%
%   y can also be a matrix containing nseg independent segments of equal
%   length npseg (segments in colums).

% S. de Waele, March 2003.

n_obs = size(ys,1);
n_seg = size(ys,2);

rc = ar_ma2rc(ar,ma,n_obs);
ar_order = length(rc)-1;

varps = vary*[1 cumprod(1-rc(2:end).^2)];

set_ar = rc2arset(rc,0:ar_order);

klihs = zeros(1,n_seg);
for L = 0:ar_order,
    par = set_ar{1+L};
    varp = varps(1+L);
    eta_hat = sum( (par(end:-1:1)'*ones(1,n_seg) ).*ys(1:L+1,:) ,1);
    klihs = klihs + log(varp)*ones(1,n_seg)+(eta_hat.^2)/varp;
end

if ar_order < n_obs-1
    par = set_ar{end};
    varp = varps(end);
    etas_hat = filter(par,1,ys);
    etas_hat = etas_hat(ar_order+2:end,:);
    klihs = klihs + (n_obs-ar_order-1)*log(varp)*ones(1,n_seg) + sum((etas_hat.^2),1)/varp;    
end