function beep2(w,t)
%plays a short tone as an audible cue
%
%USAGE:
%    beep2
%    beep2(w)    specify frequency (200-1,000 Hz)
%    beep2(w,t)     "       "       and duration in seconds

fs=8192;  %sample freq in Hz

if (nargin == 0)
   w=1000;            %default
   t = [0:1/fs:.2];   %default
elseif (nargin == 1)
   t = [0:1/fs:.2];   %default
elseif (nargin == 2)
   t = [0:1/fs:t];  
end

%one possible wave form
wave=sin(2*pi*w*t); 

%play sound
sound(wave,fs);
