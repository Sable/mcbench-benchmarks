%Voice Based Biometric System
%By Ambavi K. Patel(ambavi007@yahoo.in)
%Reference :
%1)Introduction of Speech Recognition By Berned plannerer(http://www.speech-recognition.de/)
 
function fb1=melfilter(fs1,fsize1,noc1)
fmax = fs1/2; % maximum frequency
Nmax = fsize1/2; % maximum fft index
melmax = freq2mel(fmax); % maximum mel frequency
df = fs1/fsize1; %frequency increment on linear scale ie. frequency resolution
dmel = melmax / (noc1 + 1); % frequency increment on mel scale
%center frequencies on mel scale
melcenters = (1:noc1) .* dmel;
%center frequencies in linear scale [Hz]
fcenters = mel2freq(melcenters);
%on linear scale gives corresponding indices of coefficient of power
%spectrum ie. fft indices
indexcenter = round(fcenters ./df);          %center of nc(k)
%compute start indices of windows
indexstart = [1 , indexcenter(1:noc1-1)];   %start of nc(k)= center of nc(k-1)
%compute stop indices of windows
indexstop = [indexcenter(2:noc1),Nmax];     %stop of nc(k)=center of nc(k+1)
%compute triangle-shaped filter coefficients
fb1(1:noc1,1:Nmax) =0;
for c = 1:noc1
    %left ramp
    increment = 1.0/(indexcenter(c) - indexstart(c));     %maximum amplitude is 1
    for i = indexstart(c)+1:indexcenter(c)
        fb1(c,i) = (i - indexstart(c))*increment;
    end
    %right ramp
    decrement = 1.0/(indexstop(c) - indexcenter(c));
    for i = indexcenter(c):indexstop(c)
       fb1(c,i) = 1.0 - ((i - indexcenter(c))*decrement);
    end
end
fb1=nanclr(fb1);
%figure;
%plot(fb1');

