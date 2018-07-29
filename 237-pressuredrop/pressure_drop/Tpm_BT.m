function BT = Tpm_BT(P,X)
% TPM_BT  Beattie's two-phase multiplier
% TPM_BT(P,X) Returns the Beattie two-phase 
% multipier for a steam-water system 
%  Called function: h2o_rhof(P), h2o_rhog(P), h2o_muf(P), h2o_mug(P) 
%  Required Inputs are: P - pressure (kPa), X - quality (fraction)
%  REFERENCE: BEATTIE, D.H.R., "A NOTE ON THE CALCULATION OF
%  TWO-PHASE PRESSURE LOSSES", NUCL. ENG. DES. 25, PP.395-402
% ---------------------------------------------------------------
% The MATLAB function was created by Tibor Balint, December 1998
% TBoreal Research Corporation, Toronto, Ont. Canada 
% (tibor@netcom.ca) and also, University of Warwick, UK
% ---------------------------------------------------------------

format long g;  % set the format of the calculations

% set the density and viscosity properties
   RF=h2o_rhof(P);
   RG=h2o_rhog(P);
   MUF=h2o_muf(P);
   MUG=h2o_mug(P);

% the two-phase multiplier
BT=((1+X*((RF/RG)-1))^0.8)*((1+X*((((3.5*MUG+2*MUF)*RF)/((MUG+MUF)*RG))-1))^0.2);

return     


