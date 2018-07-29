% BETALPR - Beta Distribution - Log Probability Ratio
% Copyright (c) 1998, Harvard University. Full copyright in the file Copyright
% 
%   [ lpr ] = betalpr(p1,p2,alpha,beta)
%
% returns the log of the p(p1) / p(p2) when both
% are distributed Beta(alpha,beta).
%
% See also: METROP, *LPR

function [ lpr ] = betalpr(p1,p2,alpha,beta)
lpr = (alpha-1) * log(p1/p2) + (beta-1) * log((1-p1)/(1-p2)) ;
