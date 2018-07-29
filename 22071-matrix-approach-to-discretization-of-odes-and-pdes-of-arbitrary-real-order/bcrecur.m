function y=bcrecur(a, n)
%
% Computation of the fractional difference coefficients
% by the recurrence relation
%           bc(j)=(1-(a+1)/j)*bc(j-1),
%  a - order of the fractional difference
%  n - required number of coefficients
%
%  Computation of bcrecur(k,k) takes (3*k+1) flops.
%
%  Copyright (C) Igor Podlubny
%  15 Nov 1994
% 
%  See also:
%  [1] Podlubny, I.: Fractional Differential Equations. 
%      Academic Press, San Diego, 1999, 368 pages, ISBN 0125588402.


y=cumprod([1, 1 - ((a+1) ./ (1:n))]);

