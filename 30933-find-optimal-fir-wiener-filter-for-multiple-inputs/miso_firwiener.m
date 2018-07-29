function [W, R, P] = miso_firwiener(N, X, y)
%MISO_FIRWIENER Optimal FIR Wiener filter for multiple inputs.
%   MISO_FIRWIENER(N, X, Y) computes the optimal FIR Wiener filter of 
%   order N, given any number of (stationary) random input signals as 
%   the columns of matrix X, and one output signal in column vector Y.

%   Author: Keenan Pepper
%   Last modified: 2007-12-21

%   References:
%     [1] Y. Huang, J. Benesty, and J. Chen, Acoustic MIMO Signal
%     Processing, Springer−Verlag, 2006, page 48

% Number of input channels.
M = size(X, 2);

% Input covariance matrix, in abbreviated block Toeplitz form.
R = zeros(M*(N+1), M);
for m = 1:M
    for i = 1:M
         rmi = xcorr(X(:,m), X(:,i), N);
         Rmi = flipud(rmi(1:N+1));
         top = (m-1) * (N+1) + 1;
         bottom = m * (N+1);
         R(top:bottom,i) = Rmi;
    end
end

R = reshape(R, [N+1,M,M]);      % This just permutes the indices to
R = permute(R, [2,1,3]);        % change R from Toeplitz-block to
R = reshape(R, [M*(N+1),M]);    % block-Toeplitz.

% Cross−correlation vector.
P = zeros(1, M*(N+1));
for i = 1:M
    top = (i-1)*(N+1)+1;
    bottom = i * (N+1);
    p = xcorr(y, X(:,i), N);
    P(top:bottom) = p(N+1:2*N+1)';
end

P = reshape(P, [N+1,M]);        % More index rearrangement.
P = reshape(P', [M*(N+1),1]);

W = block_levinson(P, R);

W = reshape(W, [M,N+1]);        % Make output compatible with earlier
W = reshape(W', [1, M*(N+1)]);  % version.
