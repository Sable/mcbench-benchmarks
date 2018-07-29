% This function returns the oblique shock wave angle (beta) for a given
% deflection angle (theta) in degrees and ratio of specific heats (gamma).
% and Mach number M. Specify 0 for the weak oblique shock 
% or 1 for the strong shock.
%
% Syntax:
% beta(M,theta,gamma,n)     where n specifies weak or strong shock returned
%
% NOTE: Angles supplied and returned from this function are in DEGREES.
%
% Based on an analytical solution to the theta-beta-Mach relation given in
% the following reference:  Rudd, L., and Lewis, M. J., "Comparison of
% Shock Calculation Methods", AIAA Journal of Aircraft, Vol. 35, No. 4,
% July-August, 1998, pp. 647-649.
%
% By Chris Plumley, undergraduate, University of Maryland.

function Beta=beta(M,theta,gamma,n)

theta=theta*pi/180;             % convert to radians
mu=asin(1/M);                   % Mach wave angle
c=tan(mu)^2;
a=((gamma-1)/2+(gamma+1)*c/2)*tan(theta);
b=((gamma+1)/2+(gamma+3)*c/2)*tan(theta);
d=sqrt(4*(1-3*a*b)^3/((27*a^2*c+9*a*b-2)^2)-1);
Beta=atan((b+9*a*c)/(2*(1-3*a*b))-(d*(27*a^2*c+9*a*b-2))/(6*a*(1-3*a*b))*tan(n*pi/3+1/3*atan(1/d)))*180/pi;
