% WISHIRND - Wishart Distribution - Random Matrix
% Copyright (c) 1998, Harvard University. Full copyright in the file Copyright
%
%   [W] = wishirnd(Sc,nu) 
%
% W = returned random symmetric positive definite matrix
% 
% Sc = p x p symmetric, postitive definite "scale" matrix 
% nu = "degrees of freedom" (when integer)
%    = "number of observations" (when integer)
%    (this routine assumes integer only.)
%
% uses the Odell and Feiveson (1966) algorithm
% as printed in Kennedy and Gentle (1980) 
%
% Note:
%   Different sources use different parameterizations.
%   See INVWISHRND for details.
%
% See also: INVWISHRND, INVWISHIRND

function [W] = wishirnd(Sc,n) 

d = round(n) ; 
[p,p2] = size(Sc) ;
Z = normrnd(0,1,d,p) ;
ZZ = Z'*Z ;
A = chol(Sc) ;
W = A'*ZZ*A ;
