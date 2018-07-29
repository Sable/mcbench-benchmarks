function HG = h2o_hg(P)
% H2O_HG  Saturated enthalpy of vapour at a given pressure
% H2O_HG(P) Returns the saturated enthalpy of vapour at a given 
% pressure in J/kg.  Based on the correlation (Subsection 2) given in the 
% ASME STEAM TABLES - SIXTH EDITION
% Temperature and pressure range above saturation
%  Called function: h2o_tsat(P), h2o_hs(T,P)
%  Required Inputs are: P - pressure in kPa
% ---------------------------------------------------------------
% The MATLAB function was created by Tibor Balint, December 1998
% TBoreal Research Corporation, Toronto, Ont. Canada 
% (tibor@netcom.ca) and also, University of Warwick, UK
% ---------------------------------------------------------------

format long g;  % set the format of the calculations

TS=h2o_tsat(P); % calculate the saturation temperature
% 0.001°C is added so when (TS,P) is passed on the back calculation 
% of PS(TS) will not cause a round-off error
TS=TS+0.001;  

%the saturated vapour enthalpy is
HG=h2o_hs(TS,P);
return
