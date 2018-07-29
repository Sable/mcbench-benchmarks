function [modelstring, typeflag, order] = modeltype(ar,ma)

%MODELTYPE provides a description for an ARMA-model
%   [modelstring, typeflag, order] = modeltype(AR,MA)
%
%   modelstring: AR, MA, ARMA
%   typeflag:    1   2   3
%   order: AR(p): p, MA(q): q, ARMA(r,r-1): r, NaN otherwise.
%   (ARMA setting for 'order' only for use with ARMAsel)   
%
%   Example:
%   modeltype([1 .2 .5],[1 .3])
%   modeltype: ARMA(2,1)
%
%   See also: ARMAsel.

%S. de Waele, MARCH 2001

k = length(ar)-1; l = length(ma)-1;
if ~l,
   modelstring = ['AR(' int2str(k) ')']; typeflag = 1; order = k;
elseif ~k
   modelstring = ['  MA(' int2str(l) ')']; typeflag = 2; order = l;
else
   modelstring = ['ARMA(' int2str(k) ',' int2str(l) ')']; typeflag = 3;
   if l == k-1,
       order = k;
   else
       order = NaN;
   end
end

if ~nargout,
   disp(['modeltype: ' modelstring])
   clear modelstring typeflag
end