function ac = lpcweight(ar,c)
%  lpcweight --> LPC based perceptual weighting filter.
%
%    ac = lpcweight(ar,c)
%
%    The function takes the LP coefficients, ar = [1 -a(1) ... -a(M)],
%    and the parameter, c, as inputs, and returns the coefficients of
%    the filter function A(z/c) in the vector ac.

% Linear predictor order.
M = length(ar);

% The i'th coefficient of A(z/c) is given by ar(i)*c^(i-1).
ac = ar;
ci = c;
for (i=2:M)
  ac(i) = ar(i)*ci;
  ci = ci*c;
end
