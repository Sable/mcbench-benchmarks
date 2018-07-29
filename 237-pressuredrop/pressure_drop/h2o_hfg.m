function HFG = h2o_hfg(P)
% H2O_HFG  Latent Heat of Evaporation at a given pressure
% H2O_HFG(P) Returns the Latent Heat of Evaporation at a given 
% pressure in J/kg.  Based on correlations (for Subsections 1 & 2) 
% given in the ASME STEAM TABLES - SIXTH EDITION
% Temperature and pressure range above saturation
%  Called function: h2o_tsat(P), h2o_hs(T,P), h2o_hl(T,P)
%  Required Inputs are: P - pressure in kPa
% ---------------------------------------------------------------
% The MATLAB function was created by Tibor Balint, December 1998
% TBoreal Research Corporation, Toronto, Ont. Canada 
% (tibor@netcom.ca) and also, University of Warwick, UK
% ---------------------------------------------------------------

format long g;  % set the format of the calculations

TS=h2o_tsat(P); % calculate the saturation temperature
% 0.001°C is added/deducted so when (TS,P) is passed on the back calculation 
% of PS(TS) will not cause a round-off error
TSF=TS+0.001;  
TSL=TS-0.001;  

%the saturated vapour enthalpy is
HG=h2o_hs(TSF,P);

%the saturated fluid enthalpy is
HF=h2o_hl(TSL,P);

HFG=HG-HF;
return
