function CM = Tpm_CM(P,X)
% TPM_CM  Chenoweth-Martin two-phase multiplier
% TPM_CM(P,X) Returns the Chenoweth-Martin two-phase 
% multipier for a steam-water system 
%  Called function: h2o_rhof(P), h2o_rhog(P)
%  Required Inputs are: P - pressure (kPa), X - quality (fraction)
% ---------------------------------------------------------------
% The MATLAB function was created by Tibor Balint, December 1998
% TBoreal Research Corporation, Toronto, Ont. Canada 
% (tibor@netcom.ca) and also, University of Warwick, UK
% ---------------------------------------------------------------

format long g;  % set the format of the calculations

if X<=0
   CM=1;
else
   RF=h2o_rhof(P);
   RG=h2o_rhog(P);
% Liquid Volume Fraction
   LVF=1-(X*RF/(X*RF+(1-X)*RG));
%The two-phase multiplier is
   CM=LVF^(-0.8642);
end

return     