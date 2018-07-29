function XOSV = X_osv(Q,MFLUX,HFG)
% X_osv  Onset of Significant Void
% X_osv(Q,MFLUX,HFG) Returns the Onset of Significant Void 
% the local void where in the subcooled region wall voiding 
% is initiated 
%  Called function: NONE 
%  Required Inputs are: 
%  Q is the heat flux in W/m^2,
%  MFLUX is the axially averaged mass flux in kg/sm^2,
%  HFG is the latent heat of evaporation in J/kg
%  X_osv is returned in fractions
% ---------------------------------------------------------------
% The MATLAB function was created by Tibor Balint, December 1998
% TBoreal Research Corporation, Toronto, Ont. Canada 
% (tibor@netcom.ca) and also, University of Warwick, UK
% ---------------------------------------------------------------

format long g;  % set the format of the calculations

% Calculate the boiling number
BO=Q/(MFLUX*HFG);

% Calculate the onset of significant void
XOSV=-154*BO;

return     