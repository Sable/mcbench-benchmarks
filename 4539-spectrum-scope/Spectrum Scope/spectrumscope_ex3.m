function spectrumscope_ex3
% SPECTRUMSCOPE_EX3   Spectrum scope example, using the Data Acquisition Toolbox
%
% See comments on bottom of file for extra notes on this application

%    Scott Hirsch 2-25-04
%    shirsch@mathworks.com
%    Copyright 1998-2004 The MathWorks, Inc.

%%
% Create analoginput object (Data Acquisition Toolbox)
daqreset
ai = analoginput('winsound');
chan = addchannel(ai,1:2);

%%
% Configure analoginput object
Fs = 44100;     % Sample Rate
set(ai,'SampleRate',Fs);
set(ai,'SamplesPerTrigger',4096);

%%
% Initialize scope
Nfft = ai.SamplesPerTrigger/2;                  % FFT Length.
NTraces = length(chan);                         % Number of traces on scope 
hSpectrumScope = spectrumscope(Fs,Nfft,NTraces);% Initialize spectrum scope

%%
% Configure acquisition to update scope
set(ai,'TriggerRepeat',inf)
set(ai,'TriggerFcn',{@updateplot,hSpectrumScope,Nfft});

% Put a stop button on the scope 
% This is available on MATLAB Central
if exist('daqstopbutton','file')
    daqstopbutton(gcf,ai);
else
    start(ai);
    disp('Type "stop(daqfind)" to stop the application.  Then, go to MATLAB Central and download daqstopbutton.m!');
end;


function updateplot(ai,event,hSpectrumScope,Nfft)
d = peekdata(ai,Nfft);
spectrumscope(hSpectrumScope,d);


%%
% Comments:
%
% For an application that simple gives me some real-time visualization of
% the data that I am acquiring, I prefer to use PEEKDATA instead of
% GETDATA.  Since GETDATA always grabs the oldest data in the buffer, there
% can easily be a significant lag from when an event occurs to when the
% response to the event is shown on the screen. PEEKDATA grabs the most
% recently acquired data, so it makes for much more responsive
% applications.  PEEKDATA is also non-blocking, so it won't slow down your
% application while waiting for data.  This means that you need to make
% sure there is enough data in the buffer before you call PEEKDATA.  This
% is why I set the amount of data I grab per call to peekdata (Nfft) to
% something less than the amount of data acquired per trigger.
%
% There are a bunch of different callback functions for running continuous
% applications.  I happen to like using Triggers, but you could just as
% easily use TimerFcn or SamplesAcquiredFcn