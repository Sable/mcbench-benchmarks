%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Red Noise Generation with MATLAB Implementation    %
%                                                      %
% Author: M.Sc. Eng. Hristo Zhivomirov       07/31/13  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y = rednoise(N)

% function: y = rednoise(N) 
% N - number of samples to be returned in row vector
% y - row vector of red (brown) noise samples

% The function generates a sequence of red (brown) noise samples. 
% In terms of power at a constant bandwidth, red noise falls off at 6 dB per octave. 

% difine the length of the vector
% ensure that the M is even
if rem(N,2)
    M = N+1;
else
    M = N;
end

% generate white noise with sigma = 1, mu = 0
x = randn(1, M);

% FFT
X = fft(x);

% prepare a vector for 1/(f^2) multiplication
NumUniquePts = M/2 + 1;
n = 1:NumUniquePts;

% multiplicate the left half of the spectrum so the power spectral density
% is inversely proportional to the frequency by factor 1/(f^2), i.e. the
% amplitudes are inversely proportional to 1/f
X(1:NumUniquePts) = X(1:NumUniquePts)./n;

% prepare a right half of the spectrum - a copy of the left one,
% except the DC component and Nyquist frequency - they are unique
X(NumUniquePts+1:M) = real(X(M/2:-1:2)) -1i*imag(X(M/2:-1:2));

% IFFT
y = ifft(X);

% prepare output vector y
y = real(y(1, 1:N));

% normalise
y = y./max(abs(y));

end