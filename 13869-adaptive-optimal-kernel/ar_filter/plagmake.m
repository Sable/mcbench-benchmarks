function [plag] = plagmake(nrad, nphi, nlag)
% plagmake - make matrix of lags for polar running AF
% G.A. Reina 16 Jan 2007
% Modified from the C code provided by D. L. Jones and R. G. Baraniuk
% "An Adaptive Optimal-Kernel Time-Frequency Representation"
%   by D. L. Jones and R. G. Baraniuk, IEEE Transactions on Signal 
%   Processing, Vol. 43, No. 10, pp. 2361--2371, October 1995.

plag = ((sqrt(2)*(nlag-1)* (0:(nrad-1))' ) / nrad) * ...
    sin((pi * (0:(nphi-1)) / nphi));
