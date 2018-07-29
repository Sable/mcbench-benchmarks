% INVWISHIRND - Inverse Wishart Random Matrix
% Copyright (c) 1998, Harvard University. Full copyright in the file Copyright
%
%   [IW] = invwishirnd(S,d) 
%
% S = p x p symmetric, postitive definite "scale" matrix 
% d = "degrees of freedom" parameter
%   = "precision" parameter 
%   (d must be an integer for this routine, see INVWISHRND)
%
% IW = random matrix from the inverse Wishart distribution
%
% Note:
%   different sources use different parameterizations w.r.t. nu
%   this routine uses that of Press and Shigemasu (1989):
%   density(IW) is proportional to  
%     exp[-.5*trace(S*inv(IW))] / [det(IW) ^ (d/2)].
%
%   With this density definition:
%   mean(IW) = S/(d-2p-2) when d>2p+2,
%   mode(IW) = S/d.
%
% See also: INVWISHRND, WISHRND

function [IW] = invwishirnd(S,d) 
[p,p2] = size(S) ;
W = wishirnd(inv(S),d-p-1) ;
IW = inv(W) ;
