function SIGMA = h2o_sigma(T)
% H2O_SIGMA  Surface tension of H2O in N/m
% H2O_SIGMA(T) Returns the surface tension of H2O at a given
% temperature.  Based on the correlation given in the 
% ASME STEAM TABLES - SIXTH EDITION
% Application range from the triple point (0.01°C) to
% the critical point (Tc=647.15K; 374°C)
%  Called function: NONE
%  Required Inputs are: T - temperature in °C
% ---------------------------------------------------------------
%  The MATLAB function was created by Tibor Balint, December 1998
% TBoreal Research Corporation, Toronto, Ont. Canada 
% (tibor@netcom.ca) and also, University of Warwick, UK
% ---------------------------------------------------------------

format long g;  % set the format of the calculations
   T1=T+273.15;
   TC=647.15; %critical point
if and((T1<=TC),(T>=0.01))
   %set up the recommended constants
   B=235.8E-3;
   b=-0.625;
   mu=1.256;
   SIGMA=B*(((TC-T1)/TC)^mu)*(1+b*((TC-T1)/TC));
elseif T<0.01
   error('The temperature is below range (below the triple point of 0.01°C)')
else
   SIGMA=0;
end

return
