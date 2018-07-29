function  FRIEDEL= Tpm_FR(P,X,G,DH,ERH)
% TPM_FR  Friedel two-phase multiplier
% TPM_FR(P,X,G,DH,ERH) Returns the Friedel two-phase 
% multipier for a steam-water system 
%  Called function: h2o_rhof(P), h2o_rhog(P), h2o_muf(P), 
%                   h2o_mug(P), h2o_sigma(P), h2o_rhotp(P,X),
%                   ffcw(RE,DH,ERH),
%  Required Inputs are: P  - pressure (kPa)
%                       X  - quality (fraction)
%                       G  - mass flux (kg/m^2s)
%                       DH - hydraulic diameter (m)
%                       ERH - equivalent roughness height (m)
% ---------------------------------------------------------------
% The MATLAB function was created by Tibor Balint, December 1998
% TBoreal Research Corporation, Toronto, Ont. Canada 
% (tibor@netcom.ca) and also, University of Warwick, UK
% ---------------------------------------------------------------

format long g;  % set the format of the calculations

% set the density and viscosity properties
RF=h2o_rhof(P); %sat. fluid density
RG=h2o_rhog(P); %sat. steam density
MUF=h2o_muf(P); %dynamic viscosity of sat. fluid
MUG=h2o_mug(P); %dynamic viscosity of sat. steam
SIGMA=h2o_sigma(P); %surface tension
VFG=(1/RG)-(1/RF); %diff. between steam and fluid spec.volumes
VF=1/RF; %saturated fluid specific volume

% the two-phase specific density
RHOTP=h2o_rhotp(P,X);

% the two-phase specific volume
VTP=1/RHOTP;

% the Froude number
FR=(G^2)*(VTP^2)/(9.81*DH);

% the Weber number
WE=(G^2)*DH*VTP/SIGMA;

% the Reynolds number FOR LIQUID
REF=G*DH/MUF;

% the Reynolds number FOR STEAM
REG=G*DH/MUG;

% the Colebrook-White friction factor FOR LIQUID
FCWF=ffcw(REF,DH,ERH);

% the Colebrook-White friction factor FOR STEAM
FCWG=ffcw(REG,DH,ERH);

% Calculate the Friedel correlation
% the first part of the Friedel correlation
A=((1-X)^2)+(X^2)*(RF*FCWG)/(RG*FCWF);

%  THE FRIEDEL TWO-PHASE FRICTION MULTIPLIER
FRIEDEL=A+3.21*(X^0.78)*((1-X)^0.224)*((RF/RG)^0.91)*((MUG/MUF)^0.19)*...
       ((1-(MUG/MUF))^0.7)/((FR^0.0454)*(WE^0.035));

return     
