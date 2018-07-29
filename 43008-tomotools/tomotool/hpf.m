function yn = hpf(yo)
% High-frequency Pass Filter at the same domain of y
%
% Phymhan
% 05-Aug-2013 18:08:10

N = length(yo);
%Correction function
f_corr = -2*abs((1:N)-N/2)/N+1; % ramp filter
%Fourier transform
f = fft(yo);
%Enhance high-frequency
f = f.*f_corr;
%Inverse Fourier transform
yn = ifft(f);
yn = real(yn);
end
