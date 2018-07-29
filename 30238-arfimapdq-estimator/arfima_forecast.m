%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function for computing (multistep) forecasts from linear 
% stationary AR(FI)MA(p,d,q) processes. 
%
% Input : 
%         Z : the series
%
%         s : forecast horizon
%
%         d : fractional differencing parameter
%
%        AR : 1 * p vector with [phi_1 ... phi_p]
%
%        MA : 1 * q vector with [theta_1 ... theta_p]
%
%      mean : the (unconditional) mean of the series
%
%    sigma2 : the variance of the noise sequence
%
% Output :
%
%  Z_plus_s : [Z_t+1 ... Z_t+s]' the forecasts
%
% (c) György Inzelt 2011
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Z_plus_s] = arfima_forecast(Z,s,d,AR,MA,mn,sigma2)
if ~isempty(AR) && ~isempty(MA)
        gamma_s = arfima_covs(length(Z)+s,[d(1) AR(1,:) MA(1,:) sigma2(1)],[length(AR(1,:)) length(MA(1,:))]);
    elseif isempty(AR) && ~isempty(MA)
        gamma_s = arfima_covs(length(Z)+s,[d(1) MA(1,:) sigma2(1)],[0 length(MA(1,:))]);  
    elseif ~isempty(AR) && isempty(MA)
        gamma_s = arfima_covs(length(Z)+s,[d(1) AR(1,:) sigma2(1)],[length(AR(1,:)) 0]);  
    elseif isempty(AR) && isempty(MA)
        gamma_s = arfima_covs(length(Z)+s,[d(1)  sigma2(1)],[0 0]);  
end
 [v,L] = durlevML(gamma_s);
  L = reshape(L,length(Z)+s,length(Z)+s)';
  mn = mn(1);
  Z_plus_s = zeros(s,1);
  Z_plus_s(1) = mn - L(length(Z)+1, 1: length(Z))*(Z - mn)  ;
  if s > 1
    for ii = 2:1:s
        Z_plus_s(ii) = mn - L(length(Z) + ii,1:length(Z)+ii - 1 )*( [Z;Z_plus_s(1:ii-1)] - mn) ;
    end
  end
end