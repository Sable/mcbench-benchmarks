function ar = psd2ar(h,p)

%PSD2AR Power Spectral Density Function to AR parameters.
%
%  psd2ar(h,p) calculates an AR(p) model from equidistant samples of a power
%  spectrum h.
%  
%  See also: ARMA2PSD, MODERR, SIMUARMA.

%S. de Waele, November 2001.

hs = [h fliplr(h(2:end))];
corip = ipifft(hs);
corip = corip(1:1+p)/corip(1);
ar = cov2arset(corip);

%------------------------------------------------------------------
function rho = ipifft(h)

%IPIFFT InterPolated Inverse Fast Fourier Transform
%
%  ipfft(h) considers the vector h as samples of a spectrum
%  between 0 and 2*PI. The spectrum is interpolated using
%  Nearest Neighbor interpolation.
%  If the samples in h are all positive, the resulting
%  continuous spectrum is also positive.
%
%  See also: IFFT, FFT.

%S. de Waele, October 2001.

n = length(h);
d_om = 2*pi/n; %Omega interval
r = 1:n-1;
cf = 1/d_om*2*imag(exp(i*d_om/2.*r))./r;
cf = [1 cf];
rho = real(cf.*ifft(h));
