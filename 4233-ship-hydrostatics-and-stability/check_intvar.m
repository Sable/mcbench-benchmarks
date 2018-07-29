%CHECK_INTVAR   Data file that serves to check the function intvar.
%   For details see Biran A. (2003), Ship Hydrostatics and Stability,
%   Oxford-UK: ButterworthHeinemann, Section 3.4.

x = 0: 10: 180;         % angles in degrees
phi = pi*x/180;         % angles in radians
y   = sin(phi);         % integrand
h   = 10*pi/180;        % subinterval of integration
Y = intvar(y, h);
[ x' Y' ]