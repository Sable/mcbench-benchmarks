function [frequencies, dampings, basis, ahat] = hsvd(y, fs)
%
% Decompose the signal y using the method of Barkhuijsen, et al. (1987)
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
K = estimate_model_order(s, N, L)+250;

% construct H of rank K
Uk = U(:,1:K);
Sk = S(:,1:K);
Vk = V(:,1:K);

% find Ukt and Ukb
Ukt = discardrow(1, Uk);
Ukb = discardrow(size(Uk,1),Uk);
Zp = pinv(Ukb)*Ukt;

% find the poles
[Q,D] = eig(Zp);
Z = inv(Q)*Zp*Q;
q = diag(Z);

% we could have just found the eigenvalues of course...
%q = eig(Zp);

q = log(q);

dt = 1 /fs;
dampings = real(q) / dt;
frequencies = imag(q)/(2*pi) / dt;

% construct the basis
t = (0:dt:(length(y)-1)*dt);
basis = exp(t.'*(dampings.'+j*2*pi*frequencies.'));

% compute the amplitude estimates
ahat = pinv(basis(1:length(y),:))*y;
