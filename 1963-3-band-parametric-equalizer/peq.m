% peq.m - Parametric EQ with matching gain at Nyquist frequency
% Author: Sophocles J. Orfanidis, 
% Usage:  [b, a] = peq(G0, G, w0, Dw, NdB)
%
% G0 = reference gain at DC in dB
% G  = boost/cut gain in dB
% GB = bandwidth gain in dB
%
% w0 = center frequency in Hz
% Dw = bandwidth in Hz
% NdB = amount of db less than the peak/notch gain as the bandwidth frequencies  
% b  = [b0, b1, b2] = numerator coefficients
% a  = [1,  a1, a2] = denominator coefficients

% Modified by Arvind using the equations from IIR Filter Design Chapter in
% the book
function [b, a, beta] = peq(G0, G, w0, Dw, NdB)

%Convert from Decibels to real values
GB = G * NdB;
G  = (10^(G/20));
GB = (10^(GB/20));
G0 = (10^(G0/20));

%Convert absolute frequencies to rads/sec
%w0 = w0*2*pi/fs;
%Dw = Dw*2*pi/fs;

beta = sqrt((GB^2-G0^2)/(G^2-GB^2)) * tan(Dw/2);
b = [(G0+G*beta)/(1+beta) -(2*G0*cos(w0))/(1+beta)  (G0-G*beta)/(1+beta)];
a = [1 -(2*cos(w0))/(1+beta) (1-beta)/(1+beta)];


%***********************
% double beta;
%  
% beta = sqrt((GB[0]^2-G0[0]^2)/(G^2[0]-GB[0]^2)) * tan(Dw[0]/2)
% Num[0] = (G0[0]+G[0]*beta)/(1+beta);
% Num[1] =  -(2*G0[0]*cos(w0[0]))/(1+beta) ;
% Num[2] = (G0[0]-G[0]*beta)/(1+beta);
%  
% Den[0] = 1;
% Den[1] = -(2*cos(w0[0]))/(1+beta);
% Den[2] = (1-beta)/(1+beta);
%*************************
