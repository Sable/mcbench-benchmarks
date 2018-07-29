clear all;

Fs = 20e6;     % Sampling frequency (tone - 20MHz)
L = 500;     % Length of signal
t = (0:L-1)/Fs; % Time vector

make_trig_lut;

for i1 = 1:L
    [I(i1), Q(i1)] = output_tone();
    y(i1) = I(i1) - Q(i1);
end

subplot(2,1,1);
plot(t,y);
title('y(t)')
xlabel('time (milliseconds)')

NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

% Plot single-sided amplitude spectrum.
subplot(2,1,2);
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')