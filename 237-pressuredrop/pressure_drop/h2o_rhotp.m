function RHOTPH2O = h2o_rhotp(P,X)
% H2O_RHOTP  Two-phase density of H2O in kg/m^3
% H2O_RHOTP(P,X) Returns the two-phase density 
% of H2O at a given pressure and quality.
%  Called function: h2o_rhof(P), h2o_rhog(P)
%  Required Inputs are: P - pressure (kPa), X - quality (fraction)
% ---------------------------------------------------------------
%  The MATLAB function was created by Tibor Balint, December 1998
% TBoreal Research Corporation, Toronto, Ont. Canada 
% (tibor@netcom.ca) and also, University of Warwick, UK
% ---------------------------------------------------------------

format long g;  % set the format of the calculations

RF=h2o_rhof(P);
RG=h2o_rhog(P);

INVRHOTP=(X/RG)+((1-X)/RF);
RHOTPH2O=1/INVRHOTP;
return     