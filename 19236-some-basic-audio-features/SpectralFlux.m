function F = SpectralFlux(signal,windowLength, step, fs)
signal = signal / max(abs(signal));
curPos = 1;
L = length(signal);
numOfFrames = floor((L-windowLength)/step) + 1;
H = hamming(windowLength);
m = [0:windowLength-1]';
F = zeros(numOfFrames,1);
for (i=1:numOfFrames)
    window = H.*(signal(curPos:curPos+windowLength-1));    
    FFT = (abs(fft(window,2*windowLength)));
    FFT = FFT(1:windowLength);        
    FFT = FFT / max(FFT);
    if (i>1)
        F(i) = sum((FFT-FFTprev).^2);
    else
        F(i) = 0;
    end
    curPos = curPos + step;
    FFTprev = FFT;
end