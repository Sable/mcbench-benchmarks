function [y]=bivnor(a,b,rho)
%function [y]=bivnor(a,b,rho)
%
% This function give an approximation of 
% cumulative bivariate normal probabilities
%
%                       1                    x^2 - 2*r*x*y + y^2
%    f(x,y,r)= ---------------------- exp(- ----------------------)
%               2*pi*(1-r^2)^(1/2)              2 - 2r^2
%
%    bivnor(a,b,ro)=Int(a..infinity) Int(b..infinity) f(x,y,r) dx dy
%
% Note : Mex compile the file bivnor.c before using it.
%
% Based on Fortran code in Commun. ACM oct 1973 p638 Algo 462
% Translated to C by Ajay Shah (ajayshah@usc.edu)
% Sligtly modified for Matlab compatibility by Moranvil william (moranviw@onid.orst.edu)
%
% 2004 William Moranvil (moranviw@onid.orst.edu)
%