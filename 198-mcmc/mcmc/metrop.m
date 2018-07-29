% METROP - perform a Metropolis-Hastings step
% Copyright (c) 1998, Harvard University. Full copyright in the file Copyright
%
%   [KEEPV, ACCEPT] = METROP(LOGQ,NV,OV)
%
% LOGQ = log (unnormalized) density ratio
%
%   If targ(x) is the target density (may be unnormalized)
%   and gen(x) is the generating density (may be unnormalized),
% 
%   then LOGQ = log( targ(NV) gen(OV|NV) / targ(OV) gen(NV|OV) ) 
%
% NV = new sample value
% OV = old sample value
%
% KEEPV = value of NV or OV that is kept
% ACCEPT = 1 if NV was kept, 0 if OV was kept
%
% See also: BETALPR, GAMLPR, INVWISHLPR, MVNORMLPR

function [ keepv, accept ] = metrop ( logq, newval, oldval, acc, ix ) ;

accept = acc ;

if (logq>0),
  keepv = newval ;
  accept(ix) = 1 ;
elseif (unifrnd(0,1) <= exp(logq)),
  keepv = newval ;
  accept(ix) = 1 ;
else
  keepv = oldval ;
  accept(ix) = 0 ;
end
