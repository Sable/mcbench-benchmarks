function [Y] = mnbinpdf(X, W, K)
%MNBINPDF       Maszle's negative binomial probability density function
%
%  Y = MNBINPDF(X, W, K)
%
%  returns the probabilities of the values X using a negative binomial
%  distribution with mean W and clumping parameter K.  
%
%  This is an alternate form of the negative binomial commonly
%  employed in biology to describe aggregated count data. 
%  W and K are related to the traditional parametrization by the
%  relationships: 
%
%      P = K/(K + W),  and K = R,
%
%  with the distinction that K is any positive real number, not just
%  positive integers.
%
%  X should only be integers and is rounded if not.  Calculation is
%  optimized by taking the exponential of the GAMMALN function.
%
%  See also MNBINRND



%----------------------------------------------------------------------
% Copyright (c) 1997.  Don R. Maszle.  All rights reserved.
%
%   -- Revisions -----
%      Author:  Don R. Maszle
%      E-mail:  maze@sparky.berkeley.edu
%   -- SCCS  ---------
%----------------------------------------------------------------------



%----------------------------------------------------------------------
% We use the definition from Bradley and May, Trans. R.Soc.Trop.Med.Hyg.
% v72(3), 1978, p262.


% A notational convenience
a = W/(W + K);
X = round(X);


Y = ((1 - a).^K) ...
    .* (exp( gammaln(X + K) + X.*log(a) - gammaln(K) - gammaln(X + 1)));