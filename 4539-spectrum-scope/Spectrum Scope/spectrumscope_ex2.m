function spectrumscope_ex2
% SPECTRUMSCOPE_EX2    Spectrum scope example using a timer object
% This example uses a timer object to demonstrate real-time updates of a
% spectrum scope.

%    Scott Hirsch 2-25-04
%    shirsch@mathworks.com
%    Copyright 1998-2004 The MathWorks, Inc.

%% Create data
Fs = 1024;
Nfft = 2048;
t = (0:1:Nfft-1)'/Fs;
fo = 100:5:300;         % Range of fundamental frequencies
s1 = sin(2*pi*t*fo);

%% Initialize scope
spectrumscope(Fs,Nfft);

%% Configure timer
tmr = timer;
set(tmr,'Period',.10)
set(tmr,'ExecutionMode','fixedRate');
set(tmr,'TimerFcn',@localUpdateSpectrumScope);
set(tmr,'TasksToExecute',20)
start(tmr)

function localUpdateSpectrumScope(t,event)
% Update function

% Make up data
Fs = 1024;
Nfft = 2048;
t = (0:1:Nfft-1)'/Fs;
fo = rand(1)*400+100;         % Random frequency
A = rand(1)*10;               % Random amplitude
s1 = sin(2*pi*t*fo);

% Update scope
spectrumscope(s1);
