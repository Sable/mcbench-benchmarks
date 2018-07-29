% INVWISHLPR = Inverse Wishart Distribution - Log Probability Density Ratio
% Copyright (c) 1998, Harvard University. Full copyright in the file Copyright
% 
%   [ lpr ] = invwishpdf( IW1, IW2, S, d ) ;
%
% IW = argument matrix, should be positive definite
% S = p x p symmetric, postitive definite "scale" matrix 
% d = "precision" parameter = "degrees of freeedom"
%
% lpr = probability density function, properly normalized
%
% Note: 
%   different sources use different parameterizations 
%   see INVWISHRND for details
%
% See Also: INVWISHRND, INVWISH

function [ lpr ] = invwishlpr(IW1, IW2, S, d) 

% [k,k2] = size(IW1) ;

logexpterm1 = -.5*trace(S/IW1) ;
logexpterm2 = -.5*trace(S/IW2) ;

logdetIWterm1 = log(det(IW1))*(d/2) ;
logdetIWterm2 = log(det(IW2))*(d/2) ;

lpr = logexpterm1 - logexpterm2 - logdetIWterm1 + logdetIWterm2 ;

