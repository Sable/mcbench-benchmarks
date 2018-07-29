function plotPYYf(sf,Fs)
% function plotPYYf(sf, Fs) calculates a 1024 point FFT of sf

% pass in the signal sf and the Sampling frequency Fs

nPts=1024;
SF=fft(sf,nPts);
magSF=20*log10(abs(SF(1:nPts/2)/(nPts/2)));
%Y=fft(y,nPts);
f = (0:Fs/(2*(length(magSF)-1)):(Fs/2));
%plot(f,(abs(SF(1:nPts/2))),'r',f,(abs(Y(1:nPts/2))),'g')
%plot(f,(abs(SF(1:nPts/2))),'r')
plot(f,magSF);grid;
xlabel('Frequency (Hz)');ylabel('Magnitude');title('Signal spectrum');