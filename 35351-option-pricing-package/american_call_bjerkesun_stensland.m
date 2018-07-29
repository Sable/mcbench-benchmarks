

function call_price=american_call_bjerkesun_stensland(S, K, r, b, sigma, T)


%--------------------------------------------------------------------------
%
% DESCRIPTION:
%
% Approximation of American call due to Bjerksund and Stensland (1993)
%
%
% Reference:
% 
% Petter Bjerksund and Gunnar Stensland,  
% "Closed form approximations of american options", 
% Scandinavian Journal of Management, 20(5):761-764, 1993.
%
%--------------------------------------------------------------------------
%
% INPUTS:
%
%  S:       spot price
%  K:       exercice price
%  r:       interest rate
%  b:       dividend yield
%  sigma:   volatility
%  T:       time to maturity
%
% This function uses phi1.m
%
%--------------------------------------------------------------------------
%
% OUTPUT:
%
% call_price: price of a call option
%
%--------------------------------------------------------------------------
%
% Author:  Paolo Z., February 2012
%
%--------------------------------------------------------------------------


sigma_sqr=sigma^2;
B0=max(K,(r/(r-b)*K));
beta = (0.5 - b/sigma_sqr) + sqrt( ((b/sigma_sqr-0.5)^2) + 2.0 * r/sigma_sqr);
Binf = beta/(beta-1.0)*K;
hT= - (b*T + 2.0*sigma*sqrt(T))*((K*K)/(Binf-B0));
XT = B0+(Binf-B0)*(1.0-exp(hT));
alpha = (XT-K)*(XT^-beta);
C=alpha*(S^beta) ... 
    -alpha*phi1(S,T,beta,XT,XT,r,b,sigma)...
    +phi1(S,T,1,XT,XT,r,b,sigma)...
    -phi1(S,T,1,K,XT,r,b,sigma)...
    -K*phi1(S,T,0,XT,XT,r,b,sigma)...
    +K*phi1(S,T,0,K,XT,r,b,sigma);

c=european_call_contpay(S,K,r,b,sigma,T); 

call_price = max(c,C);

