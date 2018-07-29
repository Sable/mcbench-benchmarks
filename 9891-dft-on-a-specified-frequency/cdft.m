function [amp, pha]= cdft(data, f, delt_t, wyn)
% Discrete Fourier transform (dft) on the specified frequency, not fft
%
%Input:     data:   recorded time-series data
%           f:      frequency (Hz) at which one wants to do the spectral
%                   analysis
%           delt_t: time increment (s, second) between two neighbouring data
%                   point. delt_t is related to the sampling rate, e.g. if
%                   the total data collection time is T, and the length of
%                   data is n, then delt_t = T/(n - 1).
%           wyn:    'y' -- windowing on data
%                   'n' -- no windowing applied
%Output:    amp:    amplitude of the signal
%           pha:    phase (radian) of the signal
%
% by Hongxue Cai (h-cai@northwestern.edu)

data = data(:);
n = length(data);
t = (0:n-1)*delt_t; t = t(:);

% windowing or not
if wyn == 'y'
    window = chamming(n); window = window(:);     %Hamming windowing
%     window = channing(n); window = window(:);   %Hanning windowing
    dataw = window.*data;
    k = 2;                  %Compensate for windowin. You may change a little bit for special application.
else
    dataw = data;
    k = 1;
end
%
for j = 1:length(f)
    temp1(j) = sum(data.*exp(-i*2*pi*f(j)*t));
    temp2(j) = sum(dataw.*exp(-i*2*pi*f(j)*t));
end

amp = k*abs(2*temp2/n);
pha = angle(2*temp1/n);     %radian, -pi~pi

%% Uncomment the following line if the signal is a sin wave instead of a cos wave
% pha = ph + pi/2;    

%
%% uncomment the following line if you want degree as the uint of phase
pha = pha*180/pi;

%% uncomment the following line if you want period as the uint of phase
% pha = pha/2/pi;
%
% ============= sub-functions ==================
function w = chamming(n)
%Return the n-point Hamming window.
%
if n > 1
    w = .54 - .46*cos(2*pi*(0:n-1)'/(n-1));
else
    error('n must be greater than 1.')
end
return
%
%
function w = channing(n)
%Return the n-point Hanning window in a column vector.

w = .5*(1 - cos(2*pi*(1:n)'/(n+1)));
return
