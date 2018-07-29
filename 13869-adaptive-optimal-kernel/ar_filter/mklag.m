function [delay] = mklag(nrad,nphi,nlag,iphi,jrad)
%  mklag: compute radial sample lag			
% G.A. Reina 16 Jan 2007
% Modified from the C code provided by D. L. Jones and R. G. Baraniuk
% "An Adaptive Optimal-Kernel Time-Frequency Representation"
%   by D. L. Jones and R. G. Baraniuk, IEEE Transactions on Signal 
%   Processing, Vol. 43, No. 10, pp. 2361--2371, October 1995.

delay = ((sqrt(2)*(nlag-1)*jrad)/nrad)*sin((pi*iphi)/nphi);
