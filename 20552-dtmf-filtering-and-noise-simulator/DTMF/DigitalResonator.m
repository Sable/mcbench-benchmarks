function [Y,F,Yfft,Ffft] = DigitalResonator(X,f,Fs,r)

%Function to simulate Digital Resonator
%Input Variables
%    X    = Input Signal
%    f    = analog frequency for resonator  Suggested Range (697-1477)
%    Fs   = Sampling Frequency              Default = 8000 cycles/sec
%    r    = Locating of poles               Default = 0.95
%
% Output Variables
%    Y    = Output Signal
%    F    = Impulse response of filter for input analog frequency
%    Yfft = Fourier Transform of Input signal 
%    Ffft = Fourier Transform of resonator(or for impulse response signal)
%Theory
%  Formula for digital oscillator with zeros of the digital resonator
%  placed at z = 1 and z = -1
%
%                        ( 1 - z^(-2) )
%   H(z) = G ----------------------------------------
%             1 - (2*r*cos(w0))*z^(-1)+(r^2)*z^(-2)
%
% where G is normalization factor
%
%   G = ((1-r)*(1+r^2-2*r*cos(2*w0))^1/2)/(40*(2*(1-cos(2*w0)))^1/2);
%
% H(z) can be transformed into a difference equation:
%      
%   Y(n) = 2*r*cos(w0)*Y(n-1) - r^2 * Y(n-2) - X(n)*G - X(n-2)*G
%
%    Rajiv Singla        DSP Final Project            Fall 2005
%=====================================================================


% Checking for minimum number of arguments
if nargin < 2
    error('Not enough input arguments');
end

% Setting Default values
if nargin == 1
    Fs = 8000;   
    r = 0.95;
end

% Checking for input value of r
if r <= 0 || r >= 1
    error('The value of r must be between 0 < r < 1')
end


w0 = 2*3.1416*f/Fs; 

%Computing value for normalization factor - G
Gn = (1-r)*(1+r^2-2*r*cos(2*w0))^1/2; %Numenator of G
Gd = 40*(2*(1-cos(2*w0)))^1/2; % Denominator of G
G = Gn/Gd;

%==================================================================
% Generating Output Signal
%==================================================================

%Implemention of Difference equation
X1=0; % Variable for X(n-1)
X2=0; % Variable for X(n-2)
Y1=0; % Variable for Y(n-1)
Y2=0; % Variable for Y(n-2)

Y=[]; % Initalizing output signal

for i=1:length(X)
    Y(i) = Y1*2*r*cos(w0) - Y2*r^2 + G*X(i) - G*X2;
    Y2 = Y1;
    Y1 = Y(i);
    X2 = X1;
    X1 = X(i);
end

%==================================================================
% Generating Fourier Transform for Output Signal
%==================================================================
 
Yfft = abs(fftshift(fft(Y)));

%==================================================================
% Generating Impulse response of filter at input analog frequency
%==================================================================

% Defining a Impulse function
Imp = zeros(1,length(X));
Imp(1) = 1;

%Implemention of Difference equation for impulse response function
ImpX1=0; % Variable for X(n-1)
ImpX2=0; % Variable for X(n-2)
ImpY1=0; % Variable for Y(n-1)
ImpY2=0; % Variable for Y(n-2)

F=[]; % Initalizing filter signal

for i=1:length(X)
    F(i) = ImpY1*2*r*cos(w0) - ImpY2*r^2 + G*Imp(i) - G*ImpX2;
    ImpY2 = ImpY1;
    ImpY1 = F(i);
    ImpX2 = ImpX1;
    ImpX1 = Imp(i);
end
%====================================================================
% Generating Fourier Transform for Impulse Response of Filter Signal
%====================================================================

   Ffft = abs(fftshift(fft(F)));
   
 %------------------------------------------------------------------%  