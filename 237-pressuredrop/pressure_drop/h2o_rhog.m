function RHOG = h2o_rhog(P)
% H2O_RHOG  Saturated steam density at a given pressure
% H2O_RHOG(P) Returns the saturated steam density a given pressure.  
% Based on the correlation (Subsection 2) given in the 
% ASME STEAM TABLES - SIXTH EDITION
% Called function: h2o_tsat(P), h2o_rhos(T,P) 
%  Required Inputs are: P - pressure in kPa
% ---------------------------------------------------------------
%  The MATLAB function was created by Tibor Balint, December 1998
% TBoreal Research Corporation, Toronto, Ont. Canada 
% (tibor@netcom.ca) and also, University of Warwick, UK
% ---------------------------------------------------------------

format long g;  % set the format of the calculations

if P>22120
  error('The pressure is above saturation')
end   

TS=h2o_tsat(P); % calculate the saturation temperature

RHOG=h2o_rhos(TS,P);

return

