function c = convq(x,y)
%-------------------------------------------------------------------------
%
% c = convq(x,y)
% Fast convolution between x and y using FFT.
%
% Marc Rébillat & Romain Hennequin - 02/2011
% marc.rebillat@limsi.fr / romain.hennequin@telecom-paristech.fr
%
%--------------------------------------------------------------------------

% reshaping data
x = x(:);
y = y(:);

% length of the convolued signal
Nfft = length(x)+length(y)-1;

% convolution
c = real(ifft(fft(x,Nfft).*fft(y,Nfft)));