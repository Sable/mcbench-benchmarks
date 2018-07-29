function mC = SpectralRollOff(signal,windowLength, step, c, fs)
signal = signal / max(abs(signal));
curPos = 1;
L = length(signal);
numOfFrames = (L-windowLength)/step + 1;
H = hamming(windowLength);
m = [0:windowLength-1]';
for (i=1:numOfFrames)
    window = (signal(curPos:curPos+windowLength-1));    
    FFT = (abs(fft(window,512)));
    FFT = FFT(1:255);
    totalEnergy = sum(FFT);
    curEnergy = 0.0;
    countFFT = 1;
    while ((curEnergy<=c*totalEnergy) && (countFFT<=255))
        curEnergy = curEnergy + FFT(countFFT);
        countFFT = countFFT + 1;
    end
    mC(i) = ((countFFT-1))/(fs/2);
    curPos = curPos + step;
end