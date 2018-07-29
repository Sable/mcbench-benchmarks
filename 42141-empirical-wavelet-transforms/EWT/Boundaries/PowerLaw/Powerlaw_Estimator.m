function [s,law,diff]=Powerlaw_Estimator(h)

%===============================================================
% function [s,law,diff]=Powerlaw_Estimator(h)
%
% This function compute the exponent s such that w^(-s) fit h(w)
% in the mean square error sense.
%
% Input:
%   -h: the function to fit
%
% Outputs:
%   -s: the computed exponent
%   -law: the corresponding power law w^(-s)
%   -diff: the residue |h-law| (normalized between 0 and 1)
%
% Author: Jerome Gilles
% Institution: UCLA - Department of Mathematics
% Year: 2013
% Version: 1.0
%===============================================================

h=h/max(h);
w=1:length(h);
w=w';
lw=log(w);

s=-sum(lw.*log(h))/sum(lw.^2);
law=w.^(-s);
diff=h-law;