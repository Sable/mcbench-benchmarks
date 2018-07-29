%% Spectrum Scope, Example 1
% Simple example, using a for loop

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

%% Update scope
for ii = 1:length(fo)
    spectrumscope(s1(:,ii));
    drawnow;pause(.01);
end;
