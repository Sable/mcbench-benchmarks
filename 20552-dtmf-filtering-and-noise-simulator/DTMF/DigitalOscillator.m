function [X12,x1,x2] = DigitalOscillator(f1,f2,Fs,t1)

% Function to simulate Digital Sinusodial Oscillator
% Input Variables
%    f1 = first input analog frequency    Suggested Range(697-1477)
%    f2 = second input analog frequency   Suggested Range(697-1477
%    Fs = Sampling Frequency              Default = 8000 cycles/sec
%    t1 = Tone Length                     Default = .1 sec
%
% Output Variables
%    Y  = Sine Signal for two given frequencies
%    x1 = Sine Signal for first frequency
%    x2 = Sine Signal for second frequency
%
%    Rajiv Singla        DSP Final Project            Fall 2005
%=====================================================================

% Checking for minimum number of arguments
if nargin < 2
    error('Not enough input arguments');
end

% Setting Default values
if nargin == 2
    Fs = 8000;   
    t1 = 0.1;
end

Ts=1/Fs;   %Sampling Time   
samples=t1/Ts;  %Number of samples in the tone


%% Generating first Signal 
w0=2*3.1416*f1/Fs;
A=1;
a1=-2*cos(w0);
Y1=0;
Y2=-A*sin(w0);

for n=1:samples
    x1(n)=-a1*Y1-Y2;
    Y2=Y1;
    Y1=x1(n);
end
x1=[0 x1]; %appending zero in the beginning

%% Generating second Signal
w1=2*3.1416*f2/Fs;
A=1;
a2=-2*cos(w1);
P1=0;
P2=-A*sin(w1);

for n=1:samples
    x2(n)=-a2*P1-P2;
    P2=P1;
    P1=x2(n);
end
x2=[0 x2]; %appending zero in the beginning

%% Combining both signal
X12 = .5*(x1 + x2);

