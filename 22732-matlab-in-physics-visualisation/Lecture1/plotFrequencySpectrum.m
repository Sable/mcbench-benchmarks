function plotFrequencySpectrum(sampleFrequency, signalData)
% Plot the frequency spectrum of simple harmonic motion

%   Copyright 2008-2009 The MathWorks, Inc.

% res struct has fields Position, Time

% sampleTime = res.Time(2) - res.Time(1);
% sampleFrequency = 1/sampleTime;

NFFT = 2^nextpow2(numel(signalData));
transformedSignal = fft(signalData,NFFT);
freq = sampleFrequency/2*linspace(0,1,NFFT/2+1);
stem(freq,abs(transformedSignal(1:NFFT/2+1)))
xlabel('Frequency (Hz)');
ylabel('Amplitude');
