%Load scope data
xlLoadChipScopeData('ADC.prn');

%Process signal data
Fs=40E6;
L=length(rx_i)-1;
NFFT=2*(2^nextpow2(L));
Y_i=fft(rx_i,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

%Create theoretical signal
t=(0:L-1)/Fs;
X=88*sin(2*pi*1e6*t);
X_i=fft(X,NFFT)/L;

% Plot single-sided amplitude spectrum.
plot(f,2*abs(Y_i(1:NFFT/2+1)),f,2*abs(X_i(1:NFFT/2+1)),'green');
title('Single-Sided I Channel Amplitude Spectrum of rx(t)')
xlabel('Frequency (Hz)')
ylabel('|rx(f)|')