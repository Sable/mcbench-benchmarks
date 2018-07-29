function RHOF = h2o_rhof(P)
% H2O_RHOF  Saturated density of fluid at a given pressure
% H2O_RHOF(P) Returns the saturated density at a given pressure.  
% Based on the correlation (for Subsection 1) given in the 
% ASME STEAM TABLES - SIXTH EDITION
% Temperature range from 0.0°C to 374.15°C 
% Pressure range from 0.6108kPa to 22120kPa 
%  Called function: h2o_tsat(P)
%  Required Inputs are: P - pressure in kPa
% ---------------------------------------------------------------
% The MATLAB function was created by Tibor Balint, December 1998
% TBoreal Research Corporation, Toronto, Ont. Canada 
% (tibor@netcom.ca) and also, University of Warwick, UK
% ---------------------------------------------------------------

format long g;  % set the format of the calculations

%check the pressure and temperature ranges
TS=h2o_tsat(P); % calculate the saturation temperature

if and((P>19746.77),(TS>364.638))
   error('Out of range (P>19746.77kPa and Tsat>364.638°C), due to correlation limitations')
end

PIN=P*1000; %convert the pressure from kPa to Pa
T1=TS+273.15; %convert the temperature from °C to K

% set up the constants
% the reduced temperature is calculated from theta=T/Tc1
% temperature constants used in the reduced temperature Tc1=647.3K
TC1=647.3; % and the reduced temperature is
theta=T1/TC1;

% The reduced pressure is: beta=ps/pc1
%where:  pc1=22120000 N/m^2
pc1=22120000; % and the reduced pressure is
beta=PIN/pc1;

% Primary constants for Subregion 1
A11=7.982692717e0;
A12=-2.616571843e-2;
A13=1.522411790e-3;
A14=2.284279054e-2;
A15=2.421647003e2;
A16=1.269716088e-10;
A17=2.074838328e-7;
A18=2.174020350e-8;
A19=1.105710498e-9;
A20=1.293441934e1;
A21=1.308119072e-5;
A22=6.047626338e-14;
a1=8.438375405e-1;
a2=5.362162162e-4;
a3=1.72e0;
a4=7.342278489e-2;
a5=4.975858870e-2;
a6=6.5371543e-1;
a7=1.15e-6;
a8=1.1508e-5;
a9=1.4188e-1;
a10=7.002753165e0;
a11=2.995284926e-4;
a12=2.04e-1;

Y=1-a1*theta^2-a2*theta^(-6);
Z=Y+(a3*Y^2-2*a4*theta+2*a5*beta)^0.5;

% The reduced volume is
x1=A11*a5*Z^(-5/17)+(A12+A13*theta+A14*theta^2+A15*(a6-theta)^10 ...
   +A16*(a7+theta^19)^(-1))-(a8+theta^11)^(-1)*(A17+2*A18*beta ...
   +3*A19*beta^2)-A20*theta^18*(a9+theta^2)*(-3*(a10+beta)^(-4)+a11) ...
   +3*A21*(a12-theta)*beta^2+4*A22*theta^(-20)*beta^3;

% The reduced volume for subcooled fluid in Subregin 1 is
% calculated from x1=v/vc1 where vc1=0.00317 m^3/kg
vc1=0.00317;
vl=x1*vc1;
RHOF=1/vl;

return
