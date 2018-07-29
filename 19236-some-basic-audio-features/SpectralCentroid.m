function C = SpectralCentroid(signal,windowLength, step, fs)
signal = signal / max(abs(signal));
curPos = 1;
L = length(signal);
numOfFrames = floor((L-windowLength)/step) + 1;
H = hamming(windowLength);
m = ((fs/(2*windowLength))*[1:windowLength])';
C = zeros(numOfFrames,1);
for (i=1:numOfFrames)
    window = H.*(signal(curPos:curPos+windowLength-1));    
    FFT = (abs(fft(window,2*windowLength)));
    FFT = FFT(1:windowLength);  
    FFT = FFT / max(FFT);
    C(i) = sum(m.*FFT)/sum(FFT);
    if (sum(window.^2)<0.010)
        C(i) = 0.0;
    end
    curPos = curPos + step;
end
C = C / (fs/2);