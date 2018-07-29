function MUL = h2o_mul(T,P)
% H2O_MUL  Dynamic viscosity of subcooled fluid
% H2O_MUL(T,P) Returns the dynamic viscosity of ssubcooled fluid 
% at a given temperature and pressure.
% Dynamic viscosity in (Pa s) i.e., (kg/ms)
% Based on the correlation given in Appendix 6 of the 
% ASME STEAM TABLES - SIXTH EDITION
% Range of validity of equation:
%    P<=500MPa for   0°C <= T <= 150°C
%    P<=350MPa for 150°C <= T <= 600°C
%    P<=300MPa for 600°C <= T <= 900°C
% Called function: h2o_mu(T,RHO), h2o_tsat(P), h2o_rhof(P)
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

% Get the saturated fluid density
RHOL=h2o_rhol(T,P);

% Get the dynamic viscosity of the saturated fluid
MUL=h2o_mu(T,RHOL);

return

