function [ar, ai, arN, aiN, att] = rectamake(nlag, n, forget)
% rectamake(nlag, n, forget, ar, ai, arN, aiN)
% G.A. Reina 16 Jan 2007
% Modified from the C code provided by D. L. Jones and R. G. Baraniuk
% "An Adaptive Optimal-Kernel Time-Frequency Representation"
%   by D. L. Jones and R. G. Baraniuk, IEEE Transactions on Signal 
%   Processing, Vol. 43, No. 10, pp. 2361--2371, October 1995.


trig = 2*pi/n;
decay = exp(-forget);

ar = decay*cos(trig*(0:n-1));
ai = decay*sin(trig*(0:n-1));

trigN = 2*pi*(n-(0:(nlag-1)))/n;
decayN = exp(-forget*(n-(0:nlag-1)));

   
for jj = 0:(n-1)
    
  arN(jj+1, :) = decayN .* cos(jj*trigN);
  aiN(jj+1, :) = decayN .* sin(jj*trigN);
  
end


