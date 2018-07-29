function [coax,Z0] = coaxTF(f,Zr,Len,b,a,Ur,Er,SigmaP,considerBita)
%**************************************************************
% coaxTF
%
% Generates the transfer function of coaxial cable with
% specified dielectric.

% f = frequency vector.
% Len = Length of Coaxial Cable in meter
% b = Outer Diameter in meter.
% a = Inner Diameter in meter.
% Er = Relative Permittivity of Dielectric
% Ur = Relative Permeability of Dielectric
% SigmaP = Conductivity of Dielectric
% *************************************************************
f1=abs(f);

E = Er * 8.854e-12;         %Permittivity
u = Ur*4*pi*1e-7;           %Permeability
    
C = (2*pi*E)/log(b/a);      % Capacitance 
G = (2*pi*SigmaP)/log(b/a); % Conductance
L = (u/(2*pi))*log(b/a);    % Inductance
R = 4.1577e-8*sqrt(f1)*(1/a + 1/b);  % Resistance

w = 2*pi*f1;
num = R + j*w*L;
den = G + j*w*C;
Z0= sqrt(num./den);
PL = Len*sqrt(num.*den);
if (considerBita==0),
    coax = abs(Zr./(Zr*cosh(PL) + Z0.*sinh(PL)));
else
    coax = Zr./(Zr*cosh(PL) + Z0.*sinh(PL));
end