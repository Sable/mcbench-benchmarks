function [kappa,k,theta0,P,b,ebuf,Zf,Zw] = celpana(x,L,M,c,cb,Pidx,bbuf,ebuf,Zf,Zw)
%  celpana --> CELP analyzer (coder).
%
%    [kappa,k,theta0,P,b,ebuf,Zf,Zw] = celpana(x,L,M,c,cb,Pidx,bbuf,ebuf,Zf,Zw)
%
%    The function implements a CELP coder using the following steps:
%
%    (1) Find the reflection coefficients, kappa, using M'th order
%    LP analysis on the signal frame x of length N.
%
%    (2) Find the coefficients of the filter function A(z/c) used in
%    the perceptual weighting filter.
%
%    (3) Determine the excitation parameters k, theta0, P, and b, used
%    to generate the excitation sequence, e(n). The parameters will be
%    estimated in blocks of length L, so N/L values are obtained for
%    the single input frame. Other inputs used here, are the Gaussian
%    codebook given by the L-by-K matrix cb, the pitch search range
%    Pidx(1) < P < Pidx(2), the last estimated b in bbuf, Pidx(2) previous
%    excitation samples buffered in the vector ebuf, and Zf and Zw which
%    are the memory hangover in the filters 1/A(z/c) and W(z) = A(z/c)/A(z),
%    respectively.

N = length(x);                          % Frame length.
J = N/L;                                % Number of sub-blocks.

k      = zeros(J,1);
theta0 = zeros(J,1);
P      = zeros(J,1);
b      = zeros(J,1);

[ar,xi,kappa,ehat] = lpcana(x,M);       % LP analysis of frame.
ac = lpcweight(ar,c);                   % Coefficients of filter A(z/c).

for (j=1:J)                             % Excitation sequence in blocks.
  n = (j-1)*L+1:j*L;
  [k(j),theta0(j),P(j),b(j),ebuf,Zf,Zw] = celpexcit(x(n),cb,Pidx,ar,ac,...
                                                              bbuf,ebuf,Zf,Zw);
  bbuf = b(j);                          % Last estimated b.
end
