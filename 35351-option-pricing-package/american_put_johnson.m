

function put_price=american_put_johnson(S, X, r, sigma, time)


%--------------------------------------------------------------------------
%
% DESCRIPTION:
%
% Johnson (1983) approximation to an american put price
%
%
% Reference:
%
% H. E. Johnson, 
% "An analytic approximation of the american put price", 
% Journal of Financial and Quantitative Analysis, 18(1):141-48, 1983.
% 
%--------------------------------------------------------------------------
%
% INPUTS:
%
%  S:       spot price
%  X:       exercise price
%  r:       interest rate
%  sigma:   volatility
%  time:    time to maturity
%
%--------------------------------------------------------------------------
%
% OUTPUT:
%
% put_price: price of a put option
%
%--------------------------------------------------------------------------
%
% Author:  Paolo Z., February 2012
%
%--------------------------------------------------------------------------



sigma_sqr=(sigma^2);

a0 = 3.9649 ;
a1 = 0.032325;
b0 = 1.040803;
b1 = 0.00963;

gamma = 2*r/sigma_sqr;
m  = (sigma_sqr*time)/(b0*sigma_sqr*time+b1);
Sc = X * ((gamma)/(1+gamma))^m;
l  = (log(S/Sc))/(log(X/Sc) );
alpha = ( (r*time)/(a0*r*time+a1) );

P = alpha*bs_european_put(S,X*exp(r*time),r,sigma,time) + (1-alpha)*bs_european_put(S,X,r,sigma,time);
p = bs_european_put(S,X,r,sigma,time); 

put_price = max(p,P);



