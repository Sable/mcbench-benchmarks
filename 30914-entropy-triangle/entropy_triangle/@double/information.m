function [I,EI] = information(P)
%
%[I,EI] = information(P)
% Obtains the information (pointwise) and its expectation from a distribution of 1
% or two variables, hence:
% - for Pxy a bivariate distribution:
%  [I_Pxy,H_Pxy] = information(Pxy) 
% obtains I_Pxy = log Pxy and H_Pxy is joint entropy
%
% - for Px a (row,column) univariate distribution
%  [I_Px,H_Px] = information(Px)
% obtains the self-information and the entropy.

error(nargchk(1,1,nargin));

I = -log2(P);
if nargout == 2
    lp = logical(P);
    if any(size(P) == 1)%row distribution or column distribution, resp
        EI = sum(P(lp) .* I(lp));
    else%bivariate, be very careful
        EI = sum(sum(P(lp) .* I(lp)));
    end
end
return%I,EI

