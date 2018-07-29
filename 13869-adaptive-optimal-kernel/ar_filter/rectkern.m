function kern = rectkern(itau,itheta,ntheta,nphi,req,pheq,sigma)
%   rectkern: generate kernel samples on rectangular grid
% G.A. Reina 16 Jan 2007
% Modified from the C code provided by D. L. Jones and R. G. Baraniuk
% "An Adaptive Optimal-Kernel Time-Frequency Representation"
%   by D. L. Jones and R. G. Baraniuk, IEEE Transactions on Signal 
%   Processing, Vol. 43, No. 10, pp. 2361--2371, October 1995.

iphi = floor(pheq(itheta+1, itau + 1));
iphi1 = iphi + 1;

iphi1(iphi1 > (nphi-1)) = 0;

tsigma = sigma(iphi+1) + (pheq(itheta+1, itau+1) - iphi).*(sigma(iphi1+1)-sigma(iphi+1));

%  Tom Polver says on his machine, exp screws up when the argument of
%  the exp function is too large */

kern = exp(- ( req(itheta+1, itau+1) ./ tsigma).^2 );