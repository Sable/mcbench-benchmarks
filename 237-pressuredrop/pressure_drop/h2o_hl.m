function HL = h2o_hl(T,P)
% H2O_HL  Subcooled enthalpy at a given temperature and pressure
% H2O_HL(T,P) Returns the subcooled enthalpy a given temperature
% and pressure in J/kg.  Based on the correlation (Subsection 1) given in the 
% ASME STEAM TABLES - SIXTH EDITION
% Temperature range from 0.0°C to 374.15°C 
% Pressure range from 0.6108kPa to 22120kPa 
%  Called function: h2o_psat(T), h2o_tsat(P)
%  Required Inputs are: T - temperature in °C
%                       P - pressure in kPa
% ---------------------------------------------------------------
% The MATLAB function was created by Tibor Balint, December 1998
% TBoreal Research Corporation, Toronto, Ont. Canada 
% (tibor@netcom.ca) and also, University of Warwick, UK
% ---------------------------------------------------------------

format long g;  % set the format of the calculations

%check the pressure and temperature ranges
TS=h2o_tsat(P); % calculate the saturation temperature
PS=h2o_psat(T); % calculate the saturation pressure

if T>TS
   error('Temperature is above saturation for the given pressure')
elseif PS>P  
   error('Pressure is above saturation for the given temperature')
end

PIN=P*1000; %convert the pressure from kPa to Pa
T1=T+273.15; %convert the temperature from °C to K

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
A0=6.824687741e3;
A(1)=-5.422063673e2;
A(2)=-2.096666205e4;
A(3)=3.941286787e4;
A(4)=-6.733277739e4;
A(5)=9.902381028e4;
A(6)=-1.093911774e5;
A(7)=8.590841667e4;
A(8)=-4.511168742e4;
A(9)=1.418138926e4;
A(10)=-2.017271113e3;
A(11)=7.982692717e0;
A(12)=-2.616571843e-2;
A(13)=1.522411790e-3;
A(14)=2.284279054e-2;
A(15)=2.421647003e2;
A(16)=1.269716088e-10;
A(17)=2.074838328e-7;
A(18)=2.174020350e-8;
A(19)=1.105710498e-9;
A(20)=1.293441934e1;
A(21)=1.308119072e-5;
A(22)=6.047626338e-14;
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
Yprime=-2*a1*theta+6*a2*theta^(-7);
Z=Y+(a3*Y^2-2*a4*theta+2*a5*beta)^0.5;
alfa0=0;

comp3=0;
for v=1:10
   comp3=comp3+(v-2)*A(v)*theta^(v-1);
end


% The reduced enthalpy for subcooled fluid in Subregin 1 is
% calculated from epsilon1=h/(pc1*vc1) where vc1=0.00317 m^3/kg
vc1=0.00317;

epsilon1=alfa0+A0*theta-comp3+A(11)*(Z*(17*(Z/29-Y/12)+5*theta*Yprime/12) ...
   +a4*theta-(a3-1)*theta*Y*Yprime)*Z^(-5/17) ...
   +(A(12)-A(14)*theta^2+A(15)*(a6-9*theta)*(a6-theta)^9 ...
   +A(16)*(a7+20*theta^19)*(a7+theta^19)^(-2))*beta ...
   -(a8+12*theta^11)*(a8+theta^11)^(-2)*(A(17)*beta+A(18)*beta^2+A(19)*beta^3) ...
   +A(20)*theta^18*(17*a9+19*theta^2)*((a10+beta)^(-3)+a11*beta) ...
   +A(21)*a12*beta^3+21*A(22)*theta^(-20)*beta^4;


HL=epsilon1*(pc1*vc1);
return
