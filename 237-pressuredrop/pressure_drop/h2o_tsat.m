function TSAT = h2o_tsat(P)
% H2O_TSAT  Saturation temperature at a given pressure in °C
% H2O_TSAT(P) Returns the saturation temperature at a given
% pressure.  Based on the correlation (K function) given in the 
% ASME STEAM TABLES - SIXTH EDITION
% Pressure range from 0.6108kPa to 22120kPa 
%  Called function: h2o_psat
%  Required Inputs are: P - pressure in kPa
% ---------------------------------------------------------------
%  The MATLAB function was created by Tibor Balint, December 1998
% TBoreal Research Corporation, Toronto, Ont. Canada 
% (tibor@netcom.ca) and also, University of Warwick, UK
% ---------------------------------------------------------------
format long g;  % set the format of the calculations

if or((P>22120),(P<0.61080062637844))
   if P>22120
      error('Pressure out of range (above 22120 kPa)')
   elseif P<0.61080062637844
      error('Pressure out of range (below 0.6108 kPa)')
   end
end

PIN=P*1000; %convert the pressure from kPa to Pa
TMIN=0; %set the minimum temperature to the lower range of the h2o_psat function
TMAX=374.15; %set the maximum temperature to the lower range of the h2o_psat function
TOLDGUESS=TMAX;
TNEWGUESS=TMAX;
PCALC=h2o_psat(TOLDGUESS)*1000;

% Iterate for the pressure by guessing the temperature and
% compare the result to the requested pressure input
while abs(PIN-PCALC)>0.1
   if  PIN <= PCALC
      TMAX=TOLDGUESS;
      TNEWGUESS=TMAX-(TMAX-TMIN)/2;
   else
      TMIN=TOLDGUESS;
      TNEWGUESS=TMIN+(TMAX-TMIN)/2;
   end
   
   PCALC=h2o_psat(TNEWGUESS)*1000;
   TOLDGUESS=TNEWGUESS;
end

% Assign the last iteration value to the saturation temperature
TSAT=TNEWGUESS;

return
