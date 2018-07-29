function En = SpectralEntropy(signal,windowLength,windowStep, fftLength, numOfBins);
signal = signal / max(abs(signal));
curPos = 1;
L = length(signal);
numOfFrames = floor((L-windowLength)/windowStep) + 1;
H = hamming(windowLength);
En = zeros(numOfFrames,1);
h_step = fftLength / numOfBins;

for (i=1:numOfFrames)
    window = (H.*signal(curPos:curPos+windowLength-1));
    fftTemp = abs(fft(window,2*fftLength));
    fftTemp = fftTemp(1:fftLength);
    S = sum(fftTemp);    
    
    for (j=1:numOfBins)
        x(j) = sum(fftTemp((j-1)*h_step + 1: j*h_step)) / S;
    end
    En(i) = -sum(x.*log2(x));
    curPos = curPos + windowStep;
end
