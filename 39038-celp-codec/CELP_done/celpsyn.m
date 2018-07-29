function [x,ebuf,Zi] = celpsyn(cb,kappa,k,theta0,P,b,ebuf,Zi)
%  celpsyn --> CELP synthesizer (decoder).
%
%    [x,ebuf,Zi] = celpsyn(cb,kappa,k,theta0,P,b,ebuf,Zi)
%
%    The CELP synthesizer consists of the cascade of the pitch filter
%    and the vocal-tract filter with excitation signal taken from the
%    codebook.
%
%      ------------  Gain, theta0 ----------------      ---------
%      | Gaussian |          |    |      1       |      |   1   |
%      | codebook |--------->X--->| ------------ |----->| ----- |--->
%      |   cb     | rho_k(n)      | 1 - b*z^(-P) | e(n) |  A(z) | x(n)
%      ------------               ----------------      ---------
%
%    First, the Gaussian codebook given by the L-by-K matrix cb, and
%    the excitation parameters k, theta0, P, and b, are used to generate
%    the excitation sequence, e(n). This is done in blocks of length L,
%    so if the length of the parameter vector k is J, then L*J samples
%    of e(n) are generated. The vector ebuf contains previous excitation
%    samples due to the memory hangover in the pitch filter, and the
%    length of this vector must at least be the max possible pitch period.
%
%    Then, the excitation sequence, e(n), is filtered by the vocal-tract
%    filter, 1/A(z), where the coefficients are obtained from the
%    reflection coefficients, kappa. Zi is the memory hangover in this
%    filter.
%

[L,K] = size(cb);                       % Block length and codebook size.
F = length(ebuf);                       % No. of previous excitation samples.
J = length(k);                          % No. blocks per frame.
N = L*J;                                % Frame length.

e = zeros(N,1);

for (j=1:J)
  n = (j-1)*L+1:j*L;

 % Find the signal e(n) based on the parameters b, P, theta0, and k.
 if (P(j) < L)
    Zp   = b(j)*ebuf(F-P(j)+1:F);
    e(n) = filter(1,[1 zeros(1,P(j)-1) -b(j)],theta0(j)*cb(:,k(j)),Zp);
  else
    e(n) = theta0(j)*cb(:,k(j)) + b(j)*ebuf(F-P(j)+1:F-P(j)+L);
  end
  ebuf = [ebuf(L+1:F); e(n)];           % Update e(n) buffer.
end

a = rf2lpc(kappa);                      % Convert kappa to a parameters.
[x,Zi] = filter(1,[1; -a],e,Zi);        % Vocal-tract filter.
