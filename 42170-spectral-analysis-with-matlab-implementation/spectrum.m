%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Spectrum Analysis with MATLAB Implementation     %
%                                                      %
% Author: M.Sc. Eng. Hristo Zhivomirov       06/10/13  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Xm, PhX, f] = spectrum(x, fs, varargin)

% function: [Xm, PhX, f] = spectrum(x, fs)
% x - singnal in time domain
% fs - sampling frequency, Hz
% Xm - amplitude spectrum, dB
% PhX - phase spectrum, degrees
% f - frequency vector, Hz
% type 'plot' in the place of varargin if one want to make a plot of the spectrum

%  Calculate NFFT.
nfft = length(x); 

% Windowing
win = hamming(length(x))';
x = x.*win;

% Take fft of x 
fftx = fft(x, nfft); 

% Calculate the number of unique points
NumUniquePts = ceil((nfft+1)/2); 

% FFT is symmetric, throw away second half 
fftx = fftx(1:NumUniquePts); 

% Define the coherent amplification of the window
K = sum(win)/length(x);

% Take the magnitude of fft(x) and scale it, so not to be a
% function of the length of x and window coherent amplification
% Xm = abs(fftx)/sum(win); 
Xm = abs(fftx)/length(x)/K; 

% Correction of the DC & Nyquist component
if rem(nfft, 2) % odd nfft excludes Nyquist point
  Xm(2:end) = Xm(2:end)*2;
else            % even nfft includes Nyquist point
  Xm(2:end-1) = Xm(2:end-1)*2;
end

% Convert magnitude spectrum to dB
Xm = 20*log10(Xm);

% Phase Spectrum
PhX = atan2(imag(fftx), real(fftx));

% Convert phase spectrum to degrees
PhX = PhX*180/pi;

% This is an evenly spaced frequency vector with NumUniquePts points. 
f = (0:NumUniquePts-1)*fs/nfft; 

if strcmp(varargin, 'plot');
% Generate the plots, titles and labels. 
figure
subplot(2, 1, 1)
plot(f/1000, Xm, 'r'); 
grid on
xlim([0 max(f/1000)])
ylim([-150 max(Xm)+10])
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
title('Amplitude spectrum of the signal'); 
xlabel('Frequency, kHz'); 
ylabel('Magnitude, dB'); 

subplot(2, 1, 2)
plot(f/1000, PhX, 'r')
grid on
xlim([0 max(f/1000)])
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
title('Phase spectrum of the signal'); 
xlabel('Frequency, kHz'); 
ylabel('Phase, \circ'); 
end

end