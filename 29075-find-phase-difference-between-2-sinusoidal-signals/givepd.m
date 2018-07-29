% Filename: givepd.m
% Author: Shashank G. Sawant
% email: sgsawant@gmail.com
% Description: Given 2 sinusoidal signals of the 
% same frequency, the function gives the "phase difference" between the 
% 2 given signals 
% The phase difference is in RADIANS!!!!!!
% The output is limited to pd={-pi,pi}radians
% Time Stamp: 2010 October 19 2043hrs


% pd - output phase difference (in radians)
% v - first sinusoidal signal
% i - second sinusoidal signal
% Note: v and i should have the same frequency
function pd=givepd(v,i)
L=length(v);
if(L~=length(i))
    error('The length of the 2 sinusoidal input vectors is not same!!!');
end

% The following block calculates the FFT
NFFT = 2^nextpow2(L);
V = fft(v,NFFT)/L;                  %Fourier Transform of signal v

% The following block calculates the phase of the most significant 
% frequency component
[value,index]=max(2*abs(V(1:NFFT/2+1)));
pV = angle(V(index));

% The following block calculates the FFT
NFFT = 2^nextpow2(L);
I = fft(i,NFFT)/L;                  %Fourier Transform of signal i

% The following block calculates the phase of the most significant 
% frequency component
[value,index]=max(2*abs(I(1:NFFT/2+1)));
pI = angle(I(index));

% The following is the phase difference between the 2 signals
pd=pV-pI;

% The code below limits the output to pd={-pi,pi}radians
while 1
    if pd>pi
        pd=pd-2*pi;
    elseif pd<-pi
        pd=pd+2*pi;
    else
        break;
    end
end

return;
end


















