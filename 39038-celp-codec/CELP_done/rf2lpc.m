function a = rf2lpc(kappa)
%  rf2lpc --> Convert reflection coefficients to prediction polynomial.
%
%    a = rf2lpc(kappa)
%
%    The function computes the prediction polynomial, a, based on the
%    reflection coefficients, kappa.

M = length(kappa);
a = zeros(M,1);

for (j=1:M)
  a(j)     = kappa(j);
  a(1:j-1) = a(1:j-1) - kappa(j)*a(j-1:-1:1);
end
