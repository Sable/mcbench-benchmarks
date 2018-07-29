function [Pxx, F] = calc_psd(X, NFFT, Fs, WINDOW)
% Calculate Power Spectral Density 
%	[Pxx ,F]= PSD(X, NFFT, Fs, WINDOW) estimates the Power Spectral Density of 
%	signal vector X using Welch's averaged periodogram method.  X is 
%	divided into  sections, then windowed by the WINDOW parameter
%	The magnitude squared of the length NFFT DFTs of the sections are 
%	averaged to form Pxx.  Pxx is length NFFT/2+1 for NFFT even.  the default fot  WINDOW is a rectangular window . 
% 	Fs is the sampling frequency which  is used for scaling of plots.
%
% 	Author(s): T. Krauss, 3-26-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%   Revision: Roni P, 10.8.01
%			EU, dt used in computations
%			EU, df used to get frequency scale
%   X - The signal we want to estimate the psd for.
%   NFFT - number of data points of each window
%   Fs - Sampling frequency
%   Window - The type of window to use
%	Example of use: 
%       dt = 0.01;
%       f = 10;              % Frequency to find
%       t = 0:dt:10;         % Create time vector
%       x = sin(2*pi*f*t);   % create a signal
%       nfft = 64;           % Window should be less than 256.
%       Fs = 1/dt;           % Sampling frequency
%		window = hanning(nfft); % Use hanning as window
%		[Pxx, F] = calc_psd(x, nfft, Fs, window);
%       plot(F,Pxx); xlabel('Frequency [Hz]'); ylabel('Amplitude');

if (nargin <= 2)
    error('Not enough input parameters, exiting...');
end
dt = 1/Fs;
df = 1/NFFT/dt;
if (nargin == 3)
	 w = ones(NFFT, 1);
end
if (nargin == 4)
	w = WINDOW;
	w = w(:);                        % Make sure w is a column vector
end
	
X = X(:);      				         % Make sure X is a column vector
k = fix(max(size(X)))/(NFFT);        % Number of windows
index = 1:NFFT;
KMU = k*norm(w)^2; 					 % Normalizing scale factor
w = w(:);
P = zeros(NFFT, 1);

for i=1:k
	xw = w.*X(index);
	index = index + NFFT;            % Continue to next window
	P = P + abs(fft(xw)).^2;
end

Pxx = dt*(P([2 2:NFFT/2+1]))/KMU;
n = max(size(Pxx));
F = (0:n-1)*df;