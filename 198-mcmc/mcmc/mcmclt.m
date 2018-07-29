% MCMLT - makes matrix of MCMC runs lower triangular
% Copyright (c) 1998, Harvard University. Full copyright in the file Copyright
%
%   [ Alt ] = MCMCLT(A)
%
% A = a chain of matricies, typically covariances
%
% Alt = A with all elements above the diagonal changed to NaNs
%
% Good for removing redundant trace plots and values,
% especially for samples of covariance matricies.
% 
% MCMCTRACE will not plot chains that begin with NaNs.
%
% See also: LTVEC, VECLT

function [Alt] = mcmclt(A) 

dd = size(A) ;
ll = length(dd) ;
d1 = dd(1) ;
d2 = dd(2) ;

if (ll==2),
  Alt = A ;
  for i1 = 1:d1,
  for i2 = 1:d2,
    if i2>i1,
      Alt(i1,i2)=NaN ;
    end
  end
  end
else
  Alt = A ;
  for i1 = 1:d1,
  for i2 = 1:d2,
    if i2>i1,
      Alt(i1,i2,:)=NaN ;
    end
  end
  end
end

