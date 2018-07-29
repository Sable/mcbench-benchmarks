function [frequencies, dampings, basis, ahat] = htls(y, fs)
%
% Decompose the signal y using the method of Van Huffel, et al. (1993)
%
% Obligatory arguments:
% 'y' is the FID (a linear combination of complex exponentials).
% 'fs' is the sampling frequency (bandwidth).
%
% Outputs:
% 'frequencies' - frequencies of components in signal
% 'dampings' - damping of components in signal
% 'basis' - basis vectors, one for each component
% 'ahat' - amplitudes of each basis in signal
%
% Author: Greg Reynolds (remove.this.gmr001@bham.ac.uk)
% Date: August 2006 

N = length(y);
L = floor(0.5*N);
M = N+1-L;

% H is the LxM Hankel LP matrix
H = hankel(y(1:L), y(L:N));

[U,S,V] = svd(H);
s = diag(S);

% it is always better to overestimate apparently
K = estimate_model_order(s, N, L)+10;

% construct Uk
Uk = U(:,1:K);

% find Ukt and Ukb
Ukt = discardrow(1, Uk);
Ukb = discardrow(size(Uk,1),Uk);

[U,S,V] = svd([Ukb Ukt]);
V12 = V(1:K, K+1:2*K);
V22 = V(K+1:2*K, K+1:2*K);

Zp = -V12*inv(V22);

% find the modes
q = eig(Zp);
q = log(q);

dt = 1 /fs;
dampings = real(q) / dt;
frequencies = imag(q)/(2*pi) / dt;

% construct the basis
t = (0:dt:(length(y)-1)*dt);
basis = exp(t.'*(dampings.'+j*2*pi*frequencies.'));

% compute the amplitude estimates
ahat = pinv(basis(1:length(y),:))*y;
