function [frequencies, dampings, basis, ahat] = lpsvd(y, fs)
%
% Decompose the signal y using the method of Kumaresan and Tufts (1982).
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

% choose the number of points to use
N = length(y);
L = floor(0.5*N);

% find the coefficients of the polynomial
A = conj(hankel(y(2:N+1-L), y(N+1-L:N)));
h = y(1:N-L);

% this is the method described in the paper... but it doesn't
% seem to work very well for me
% [U, S, V] = svd(A);
% s = diag(S);
% M = estimate_model_order(s, N, L) + 8;
% S(S > s(M)) = 0;
% b = zeros(L,1);
% for k =1:1:M
%     uk = U(:,k);
%     b = b + (1/s(1))*(uk'*h)*V(:,k);
% end
% b= -b;
% b = b.';

% we want to find b so as to minimise its Euclidean length
b = pinv(A) * -h;
b = b.';

% time step
dt = 1 / fs;

% find roots of prediction error filter equation
qr = roots([b 1]);

% find the poles we are interested in using Kumaresan's cunning criteria
quse = qr(find(abs(qr) >= 1));

% convert poles to parameters
q = -conj(log(quse));
dampings = real(q) / dt;
frequencies = imag(q)/(2*pi) / dt;

% construct the basis
t = (0:dt:(length(y)-1)*dt);
basis = exp(t.'*(dampings.'+j*2*pi*frequencies.'));

% compute the amplitude estimates
ahat = pinv(basis(1:length(y),:))*y;
