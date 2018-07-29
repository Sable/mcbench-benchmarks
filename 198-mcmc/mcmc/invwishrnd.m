% INVWISHRND - Inverse Wishart Distribution - Random Matrix Value
% Copyright (c) 1998, Harvard University. Full copyright in the file Copyright
%
%   [ IW ] = invwishrnd(S,d) 
%
% S = p x p symmetric, postitive definite "scale" matrix 
% d = "degrees of freedom" parameter (integer)
%   = "precision" parameter (d may be non-integer)
%
% IW = random matrix from the inverse Wishart distribution
%
% Note:
%   Different sources use different parameterizations.
%   This routine uses that of Press and Shigemasu (1989):
%   density (IW) is proportional to  
%     exp[-.5*trace(S*inv(IW))] / [det(IW) ^ (d/2)].
%
%   With this density definition:
%   mean of IW = S/(d-2p-2) for d>2p+2,
%   mode of IW = S/d.
%
% See also: INVWISHIRND, WISHRND

function [IW] = invwishrnd(S,d) 

[p,p2] = size(S) ;

W = wishrnd(inv(S),d-p-1) ;

IW = inv(W) ;

