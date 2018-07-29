% GAMLPR = Gamma Distribution - Log Probability Density Ratio
% Copyright (c) 1998, Harvard University. Full copyright in the file Copyright
% 
%   [ lpr ] = gamlpr( g1, g2, alph, gam ) 
%
% returns log ( p(g1)/p(g2) ) when g1 and g2 are
% distributed gamma(alph,gam)
%

function [ lpr ] = gamlpr(g1, g2, alph, gam) 
lpr = (alph-1)*log(g1/g2)  - (g1-g2)/gam ;
