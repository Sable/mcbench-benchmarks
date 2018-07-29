

function call_price=american_call_perpetual(S, K, r, q, sigma)


%--------------------------------------------------------------------------
%
% DESCRIPTION:
%
% Price for an american perpetual call option
%
%
% Reference:
%
% John Hull, "Options, Futures and other Derivative Securities",
% Prentice-Hall, second edition, 1993.
% 
%--------------------------------------------------------------------------
%
% INPUTS:
%
%  S:       spot price
%  K:       exercice price
%  r:       interest rate
%  q:       dividend yield 
%  sigma:   volatility
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


sigma_sqr=(sigma^2);
h1 = 0.5 - ((r-q)/sigma_sqr);
h1 = h1 + sqrt( (((r-q)/sigma_sqr-0.5)^2)+2.0*r/sigma_sqr );

call_price=(K/(h1-1.0))*( (((h1-1.0)/h1)*(S/K))^h1 );
