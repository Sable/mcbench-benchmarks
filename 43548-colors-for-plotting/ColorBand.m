function C = ColorBand( N )
%COLORBAND Summary of this function goes here
%   Detailed explanation goes here

n = (1:N)';
R = exp(-(2*n/N).^2);
G = exp(-(2*(n-N/2)/N).^2);
B = exp(-(2*(n-N)/N).^2);
C = [R,G,B];



end

