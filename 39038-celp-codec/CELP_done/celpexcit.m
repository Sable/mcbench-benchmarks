function [k,theta0,P,b,ebuf,Zf,Zw] = celpexcit(x,cb,Pidx,ar,ac,b,ebuf,Zf,Zw)
%  celpexcit --> CELP excitation sequence.
%
%    [k,theta0,P,b,ebuf,Zf,Zw] = celpexcit(x,cb,Pidx,ar,ac,b,ebuf,Zf,Zw)
%
%    The function determines the excitation parameters k, theta0, P,
%    and b, used to generate the excitation sequence, e(n), for the speech
%    block x(n) of length L as illustrated below.
%
%        ------------    Gain, theta0  ----------------
%        | Gaussian |            |     |      1       |
%        | codebook |----------->X---->| ------------ |----> e(n)
%        |   cb     | rho_k(n)         | 1 - b*z^(-P) |
%        ------------                  ----------------
%
%    The sequence rho_k(n) is selected from a Gaussian codebook, L-by-K
%    matrix cb, of stored sequences, where 1 < k < K is the index. Then
%    the sequence is amplified by theta0, and filtered by a long-delay
%    correlation filter used to generate the pitch periodicity in voiced
%    speech. Thus, e(n) is given by
%
%        e(n) = theta_0*rho_k(n) + b*e(n-P)
%    
%    The parameters are obtained by using analysis-by-synthesis method,
%    where the parameters P and b in the pitch synthesis filter are
%    estimated in the range Pidx(1) < P < Pidx(2) and 0 < b < 1.4. Note,
%    that the last estimated b, and Pidx(2) previous excitation samples
%    buffered in the vector ebuf must be given as input.
%
%    Finally, ar = [1 -a(1) ... -a(M)] is a vector with the estimated
%    LP parameters, ac is the coefficients of the filter function A(z/c),
%    and Zf and Zw are the memory hangover in the filters 1/A(z/c) and
%    W(z) = A(z/c)/A(z), respectively.
%

[L,K] = size(cb);                       % Block length and codebook size.
F = length(ebuf);                       % No. of previous excitation samples.

% The columns of E are the signal e(n-P) for Pidx(1) < P < Pidx(2).
E = zeros(L,Pidx(2)-Pidx(1)+1);

% For P < L, the signal e(n-P) is estimated as the output of the pitch
% filter with zero input. b*ebuf(F-P+1:F) is memory hangover in the filter.
if (Pidx(1) < L)
  if (Pidx(2) < L)
    P2 = Pidx(2);
  else
    P2 = L;
  end
  for (P = Pidx(1):P2-1)
    i = P - Pidx(1) + 1;
    E(:,i) = filter(1,[1 zeros(1,P-1) -1],zeros(L,1),b*ebuf(F-P+1:F));
  end
end

% For P >= L, the signal e(n-P) can be obtained from previous excitation
% samples only, buffered in the vector ebuf.
if (Pidx(2) >= L)
  if (Pidx(1) >= L)
    P1 = Pidx(1);
  else
    P1 = L;
  end
  col = ebuf(F-P1+1:F-P1+L);
  row = flipud(ebuf(F-Pidx(2)+1:F-P1+1));
  i = P1-Pidx(1)+1:Pidx(2)-Pidx(1)+1;
  E(:,i) = toeplitz(col,row);
end

% First, b and P are determined to minimize the error energy between
% X(z)*W(z) and b*E(z)*z^(-P) / A(z/c).

[zeta_w0,Zw] = filter(ar,ac,x,Zw);      % zeta_w0 = X(z)*W(z).
Zeta_w2 = filter(1,ac,E,Zf);            % Zeta_w2 = E(z)*z^(-P) / A(z/c)
                                        % for Pidx(1) < P < Pidx(2).
P_w2  = sum(Zeta_w2.^2);         % Vector with signal power for each P.
P_w02 = zeta_w0'*Zeta_w2;        % Vector with cross-correlations for each P.

[xi,Phat] = max(P_w02.^2./(P_w2 + 10*eps));  % Find index Phat of max value.
P = Phat + Pidx(1) - 1;                      % Offset index with first P.
b = abs(P_w02(Phat)/(P_w2(Phat) + 10*eps));  % b must be larger than 0,
if (b > 1.4)                                 % and less than 1.4.
  b = 1.4;
end

% Find the signal e(n-P) based on the estimated b and P.
if (P < L)
  e = filter(1,[1 zeros(1,P-1) -b],zeros(L,1),b*ebuf(F-P+1:F));
else
  e = b*ebuf(F-P+1:F-P+L);
end

% Now, k and theta0 are determined to minimize the error energy between
% X(z)*W(z) - b*E(z)*z^(-P)/A(z/c) and theta0*rho_k(z)/A(z/c).

zeta_w0 = zeta_w0 - filter(1,ac,e,Zf);  % Subtract b*E(z)*z^(-P)/A(z/c).
Zeta_w1 = filter(1,ac,cb);              % Zeta_w1 = rho_k(z) / A(z/c)
                                        % for all index k in codebook.
P_w1  = sum(Zeta_w1.^2);         % Vector with signal power for each P.
P_w01 = zeta_w0'*Zeta_w1;        % Vector with cross-correlations for each P.

[xi,k] = max(P_w01.^2./P_w1);           % Find index k of max value,
theta0 = P_w01(k)/P_w1(k);              % and gain theta0 using this k.

% Find the signal e(n) based on the estimated b, P, theta0, and k.
if (P < L)
  e = filter(1,[1 zeros(1,P-1) -b],theta0*cb(:,k),b*ebuf(F-P+1:F));
else
  e = theta0*cb(:,k) + b*ebuf(F-P+1:F-P+L);
end
ebuf = [ebuf(L+1:F); e];                % Update e(n) buffer.

[zeta,Zf] = filter(1,ac,e,Zf);          % Update memory hangover in 1/A(z/c).
