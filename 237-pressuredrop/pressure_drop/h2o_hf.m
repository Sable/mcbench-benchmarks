function HF = h2o_hf(P)
% H2O_HF  Saturated enthalpy of fluid at a given pressure
% H2O_HF(P) Returns the saturated enthalpy of fluid at a given 
% pressure in J/kg.  Based on the correlation (Subsection 1) given in the 
% ASME STEAM TABLES - SIXTH EDITION
% Temperature range from 0.0°C to 374.15°C 
% Pressure range from 0.6108kPa to 22120kPa 
%  Called function: h2o_tsat(P), h2o_hl(T,P)
%  Required Inputs are: P - pressure in kPa
% ---------------------------------------------------------------
% The MATLAB function was created by Tibor Balint, December 1998
% TBoreal Research Corporation, Toronto, Ont. Canada 
% (tibor@netcom.ca) and also, University of Warwick, UK
% ---------------------------------------------------------------

format long g;  % set the format of the calculations

TS=h2o_tsat(P); % calculate the saturation temperature
% 0.001°C is deducted so when (TS,P) is passed on the back calculation 
% of PS(TS) will not cause a round-off error
TS=TS-0.001;  

%the saturated fluid enthalpy is
HF=h2o_hl(TS,P);
return
