function [fo, ip] = func_excludeoutlier_cor( fi, g, g_s );
%======================================================================
%
% Version 1.0
%
% This program excludes the points which below g_s of g
%
% Input
%   fi : input x data
%
% Output
%   fo : excluded x data
%   ip : excluded array element number in xi and yi
%
% Example: 
%   [fo, ip] = func_excludeoutlier_cor( fi, g, g_s );
%
%
%======================================================================
% Terms:
%
%       Distributed under the terms of the terms of the BSD License
%
% Copyright:
%
%       Nobuhito Mori, Kyoto University
%
%========================================================================
%
% Update:
%       1.00    2005/01/12 Nobuhito Mori
%
%========================================================================

n = max(size(fi));
fo = [];
ip = find(g<g_s);
%fo = fi(find(g>=g_s));
fo =fi;
fo(ip) = NaN;
