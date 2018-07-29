function makeBeep(w,t)

%it was called function beep2(w,t) before Peggy Chen modified it
%
%plays a short tone as an audible cue
%
%USAGE:
%    beep2
%    beep2(w)    specify frequency (200-1,000 Hz)
%    beep2(w,t)     "       "       and duration in seconds
%
% On 06/03/04, Peggy Chen download this code from
% http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=207&objectType=file 
% The programer: Dave Johnson of Raytheon Missile Systems Co
% Code modified by Peggy Chen with psychtoolbox

fs=65000;  %sample freq in Hz (1000-65535 Hz)   
           % it was 8192 when using SOUND command at the end of this code

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

% play sound
% SOUND(wave,fs);
% however, SOUND command cannot play more than 200 beeps successively
% and an error message will show as below
% %??? Unable to write into sound device
% Error in ==> C:\MATLAB6p5\toolbox\matlab\audio\private\playsnd.dll
% Error in ==> C:\MATLAB6p5\toolbox\matlab\audio\sound.m 
% On line 36  ==> playsnd(y,fs,bits);
% 
% let's try psychtoolbox in order to play more than 200 beeps
% I need 1-10 beeps in a trial, and there are 225 trials in my experiment
SND('Play',wave,fs); 
SND('Wait');
SND('Quiet');
SND('Close');