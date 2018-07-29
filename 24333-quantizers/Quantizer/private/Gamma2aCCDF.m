function P = Gamma2aCCDF (v, a)
% This function calculates the complementary cumulative probability
% distribution function (CDF) for a unit-variance (two-sided) generalized
% gamma probability density function (PDF) with parameter a,
%
%   p(x,a) = b exp(-b|x|) (b|x|)^(a-1) / (2 G(a)),   a >= 0.
%
% where G(a) is the complete gamma function.
%
% The complementary cumulative distribution function is
%                       inf
%   G(v,a) = b/(2 G(a)) Int exp(-b|x|) (b|x|)^(a-1) dx.
%                        v
% To develop this formula, we start from the one-sided gamma PDF
%
%  G(x,a) = 1/G(a) exp(-x) x^(a-1),  for x >= 0,
%         = 0,                       for x < 0.
% We now make the PDF two-sided
%   Gamma2PDF(x,a) = 1/2 GammaPDF(|x|,a).
% This is a zero-mean (symmetric) distribution. Its variance can be
% calculated integrating the product of t^2 and Gamma2PDF(x,a). But
% multiplying the PDF by t^2 is the same as replacing the exponent a-1
% by a+1. Then the variance is
%   Var(Gamma2PDF(x,a) = G(a+2)/G(a) = a(a+1),
% since G(a+1) = a G(a).
%
% Let the standard deviation be denoted as b = sqrt(a(a+1)). Then scaling
% x by b and scaling the result, gives the unit-variance generalized gamma
% density shown above. The complementary cumulative distribution function
% is then (for v >= 0),
%                      inf
%  G(v,a) = b/(2 G(a)) Int exp(-b|x|) (b|x|)^(a-1) dx 
%                       v
%                      inf
%         = 1/(2 G(a)) Int exp(-u) u^(a-1) du
%                      bv
%         = 1/2 Gamma1aCCDF(bv,a).

% Moments
% Let p(x,a1) be the generalized gamma distribution with parameter a1.
%   F0(x,a1) = Int(x,Inf) p(x,a1) dx
% The moment integrals are
%   Fn(x,a1) = Int(x,Inf) x^n p(x,a1) dx
%            = G(a2)/(G(a1) b1^n) F0(b1 x/b2, a2)       n even
%            = G(a2)/(G(a1) b1^n) F0(b1 abs(x)/b2, a2), n odd
% where a2=a1+n, b1=sqrt(b1(b1+1)), and b2=sqrt(a2(a2+1)). Note that the
% generalized gamma PDF uses abs(x). So for odd moments (n odd), we have to
% compensate by changing the sign of the argument.

% Gaussian
% The Gaussian complementary cumulative distribution function can be
% computed from the generalized gamma distribution. Consider the moments
% of the Gaussian distribution
%   Fn(u) = 1/sqrt(2pi) Int u^n e^(-u^2/2) du
% Consider u positive. Substitute x = u^2/(2b) with u = sqrt(2bx). Then
% du = b/sqrt(2) 1/sqrt(bx), giving
%   Fn(x) = 1/sqrt(2pi) Int (2bx)^(n/2) e^(-bx) b/sqrt(2) 1/sqrt(bx) dx
%         = 1/sqrt(2pi) 2^(n/2)/sqrt(2) b Int (bx)^((n-1)/2) e^(-bx) dx
% Let a = (n+1)/2,
%   Fn(x) = 2^(n/2) G(a)/sqrt(pi) b/(2G(a)) Int exp(-bx) (bx)^(a-1) dx
%         = 2^(n/2) G(a)/sqrt(pi) G(x,a)  with x>0 and b=sqrt(a(a+1)).
%
% For the integral of the Gaussian, n=0, a=1/2, b=sqrt(3)/2), and
% G(a)=sqrt(pi))
%   F0(x) = G(x,1/2)
% or
%   F0(u) = G(sgn(x) x^2/(2b),1/2).
% The sgn() function compensates for the loss of sign information in
% squaring x.
%
% The Gaussian first moment is given by n=1, a=1, b=sqrt(2), and
% G(a)=sqrt(2),
%   F1(u) = sqrt(2/pi) G(x^2/(2b), 1)
% The sgn() function is not necessary since the integrand is odd.
%
% The Gaussian second moment is given by n=2, a=3/2, b=sqrt(3)/2, and
% G(a)=sqrt(pi)/2,
%   F2(u) = G(sgn(x) x^2/(2b), 3/2)

b = sqrt(a*(a+1));
if (v >= 0)
  P = (1/2) * Gamma1aCCDF(b*v, a);
else
  P = 1 - (1/2) * Gamma1aCCDF(-b*v, a);
end

return
