function [H]=freqresp(b,a,w) 
% Frequency response function from difference equation 
% [H] = freqresp(b,a,w) 
% H = frequency response array evaluated a w frequencies 
% b = numerator coefficient array 
% a = denominator coefficient array (a(1)=1) 
% w = frequency location array 
m = 0:length(b)-1;
l = 0:length(a)-1;
num = b*exp(-j*m'*w); 
den = a*exp(-j*l'*w); 
H = num./den;