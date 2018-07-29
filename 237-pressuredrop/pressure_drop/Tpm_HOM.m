function HOM = Tpm_HOM(P,X)
% TPM_HOM  Homogeneous model two-phase multiplier
% TPM_HOM(P,X) Returns the Homogeneous model two-phase 
% multipier for a steam-water system 
%  Called function: h2o_rhof(P), h2o_rhog(P), h2o_muf(P), h2o_mug(P) 
%  Required Inputs are: P - pressure (kPa), X - quality (fraction)
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
   
% Specific volume: v_fg and v_f
SPVFG=(1/RG)-(1/RF);
SPVF=1/RF;

% the two-phase multiplier
HOM=(1+X*(SPVFG/SPVF))*(1+X*(MUF-MUG)/MUG)^(-0.25);
return     