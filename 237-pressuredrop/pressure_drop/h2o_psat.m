function PSAT = h2o_psat(T)
% H2O_PSAT  Saturation pressure at a given temperature in kPa
% H2O_PSAT(T) Returns the saturation pressure at a given
% temperature.  Based on the correlation (K function) given in the 
% ASME STEAM TABLES - SIXTH EDITION
% Temperature range from 0.0°C to 374.15°C 
%  Called function: NONE
%  Required Inputs are: T - temperature in °C
% ---------------------------------------------------------------
% The MATLAB function was created by Tibor Balint, December 1998
% TBoreal Research Corporation, Toronto, Ont. Canada 
% (tibor@netcom.ca) and also, University of Warwick, UK
% ---------------------------------------------------------------

format long g;  % set the format of the calculations

if or((T>374.15),(T<0.01))
   if T>374.15
      error('Temperature out of range (above 374.15°C)')
   elseif T<0.0
      error('Temperature out of range (below 0.0°C)')
   end
end

T1=T+273.15;
% set up the constants
% the reduced temperature is calculated from theta=T/Tc1
% temperature constants used in the reduced temperature Tc1=647.3K
TC1=647.3;
%the reduced saturation pressure is calculated from
% betaK(theta)=ps/pc1, where ps=ps(T)
%pc1=22120000 N/m^2
pc1=22120000;

%Saturation line constants from k1 to k9
k=[-7.691234564e0
   -2.608023696e1
   -1.681706546e2
   6.423285504e1
   -1.189646225e2
   4.167117320e0
   2.097506760e1
   10^9
   6];

% build up the correlation
a1=0;
for v=1:5
   s(v)=k(v)*(1-(T1/TC1))^v;
   a1=a1+s(v);
end

a2=1/(T1/TC1);
a3=(1-(T1/TC1));
a4=1+k(6)*a3+k(7)*a3^2;
a5=k(8)*a3^2+k(9);

%the reduced saturation pressure is
betaK=exp(a2*(a1/a4)-(a3/a5));

% betaK(theta)=ps/pc1, where ps=ps(T)
PSAT=betaK*pc1/1000; %saturation pressure in kPa

return
