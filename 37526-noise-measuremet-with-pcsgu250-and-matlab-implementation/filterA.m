function xA = filterA(f, x)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILTERA Generates an A-weighting filter.              %
% FILTERA Uses a closed-form expression to generate     %
% an A-weighting filter for arbitary frequencies.       %
%                                                       %
% Authors: Douglas R. Lanman, 11/21/05                  %
%          Hristo Zhivomirov, 07/15/12                  %
%                                                       %
% Define filter coefficients:                           %
% IEC 61672:2003                                        %
% See also: http://www.beis.de/Elektronik/AudioMeasure/ %
%           WeightingFilters.html#A-Weighting           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

c1 = 3.5041384e16;
c2 = 20.598997^2;
c3 = 107.65265^2;
c4 = 737.86223^2;
c5 = 12194.217^2;

% Evaluate A-weighting filter.
f(find(f == 0)) = eps;
f = f.^2;
num = c1*f.^4;
den = ((c2+f).^2) .* (c3+f) .* (c4+f) .* ((c5+f).^2);
A = num./den;

% Filtering
N = length(x);
NUP = ceil((N+1)/2); % Calculate the number of unique points (NUP)
X = fft(x);
X = X(1:NUP); % X = 2*X(1:NUP)/NUP;
X(1,1) = X(1,1)/2; % DC correction
X(1, end) = X(1, end)/2; % Nyquist frequency correction
XA = X.*A; % Filtering
xA = real(ifft(XA)); % xA = real(ifft(XA)*NUP/2);