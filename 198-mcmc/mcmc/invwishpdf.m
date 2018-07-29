% INVWISHPDF = Inverse Wishart Distribution - Probability Density Function
% Copyright (c) 1998, Harvard University. Full copyright in the file Copyright
% 
%   [pdf] = invwishpdf( IW, S, d ) ;
%
% IW = argument matrix, should be positive definite
% S = p x p symmetric, postitive definite "scale" matrix 
% d = "precision" parameter = "degrees of freeedom"
%
% pdf = probability density function, properly normalized
% logpdf = log(pdf)
%
% Note:
%   different sources use different parameterizations w.r.t. d
%   this routine uses that of Press and Shigemasu
%   density(IW) is proportional to  
%     exp[-.5*trace(S*inv(IW))] / [det(IW) ^ (d/2)]
%
%   With this density definitions,
%   mean(IW) = S/(d-2p-2),
%   mode(IW) = S/d.
%
% See also: INVWISHRND, INVWISHIRND, INVWISHLPR, WISHRND

function [ pdf, logpdf ] = invwishpdf(IW,S,d) 

[k,k2] = size(IW) ;

logexpterm = -.5*trace(S/IW) ;
logdetIWterm = log(det(IW))*(d/2) ;
logdetSterm = log(det(S))*((d-k-1)/2) ;
logtwoterm = log(2)*((d-k-1)*k/2) ;
logpiterm = log(pi)*((k-1)*k/4) ;

klst = 1:k ;
dkk2 = (d-k-klst)/2 ;
gamln = gammaln(dkk2) ;
sumgamln = sum(gamln) ;

logpdf = logexpterm + logdetSterm - ...
         (logdetIWterm + logtwoterm + logpiterm + sumgamln  ) ;

pdf = exp(logpdf) ;

