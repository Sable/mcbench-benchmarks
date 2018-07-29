function Z = zcr(signal,windowLength, step, fs);
signal = signal / max(abs(signal));
curPos = 1;
L = length(signal);
numOfFrames = floor((L-windowLength)/step) + 1;
%H = hamming(windowLength);
Z = zeros(numOfFrames,1);
for (i=1:numOfFrames)
    window = (signal(curPos:curPos+windowLength-1));    
    window2 = zeros(size(window));
    window2(2:end) = window(1:end-1);
    Z(i) = (1/(2*windowLength)) * sum(abs(sign(window)-sign(window2)));
    curPos = curPos + step;
end




