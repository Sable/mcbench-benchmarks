function [Cl,Cd,xcp]=a2clcdxc(alfa)

% [Cl,Cd,xcp]=a2clcdxc(alfa) computes hydrodynamic coefficients Cl and Cd
% for the body, and distance between prow and force application point xcp

% Costants
CD0 = 0.185;
CD90 = 4.773;
ALFA1 =0.5236;
ALFA2 =1.047;

C1 =1.64;             % interpolating coefficients
C2 = 2.387;
C3 =1.971;
C4 =0.481;
C5 =-4.861;
C6 =7.635;
K1 = 0.124;
K2 = 0.243;

% sign correction
mod_alfa=abs(alfa-sign(alfa)*(abs(alfa)>pi/2)*pi);

Cd = CD0 + (CD90 - CD0) * sin(mod_alfa)^3;
xcp = K1*mod_alfa + K2*mod_alfa^0.5;

if mod_alfa < ALFA1    Cl = C1*mod_alfa +C2*mod_alfa^2;
elseif mod_alfa < ALFA2     Cl = C3*mod_alfa +C4;
else    Cl = C5*mod_alfa +C6;
end

% sign correction
Cl = Cl*sign(sin(2*alfa));
xcp =  xcp*sign(cos(alfa)) + (abs(alfa)>pi/2);
