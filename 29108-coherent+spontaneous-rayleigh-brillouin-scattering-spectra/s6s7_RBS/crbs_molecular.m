% Written by John Smith
% October 21st, 2010
% University of Colorado at Boulder, CIRES
% John.A.Smith@Colorado.EDU
% MATLAB version 7.10.0.59 (R2010a) 64-bit
% Adapted from "Coherent Rayleigh-Brillouin Scattering"
% by Xingguo Pan

% Sets and computes all relevant parameters
% for s6 and s7 models given in Xingguo Pan's
% dissertation entitled "Coherent Rayleigh-
% Brillouin Scattering", 2003, Princeton Univ.

% set the temperature of the gas
tem=292;
p_atm=3;

% create the domain of xi
N=1000;
xi_lef=-5.0d0;
xi_rgt=5.0d0;
xi=linspace(xi_lef,xi_rgt,N);

% set fundamental constants
kb=1.3806503e-23;

% set laser parameters
lambda=366.512e-9;
angle=(89.4)*(pi/180);
k=sin(angle)*4*pi/lambda;

% set N2 gas quantities
m_m=(1.66053886e-27)*28.013;
viscosity=17.63e-6;
bulk_vis=viscosity*0.73;
thermal_cond=25.2e-3;
c_int=1.0;

% compute most probable gas velocity
v0=sqrt(2*kb*tem/m_m);

% convert pressures and densities
p_pa=p_atm*1.01325e5;
p_torr=p_pa*0.00750061683;
n0=p_pa/(tem*kb);

% compute and set RBS model input parameters
c_tr=3/2;
y=n0*kb*tem/(k*v0*viscosity);
gamma_int=c_int/(c_tr+c_int);
rlx_int=1.5*bulk_vis/(viscosity*gamma_int);
eukenf=m_m*thermal_cond/(viscosity*kb*(c_tr+c_int));

% run the code
[cohsig7,sptsig7]=crbs7(y,rlx_int,eukenf,c_int,c_tr,xi);
[cohsig6,sptsig6]=crbs6(y,rlx_int,eukenf,c_int,c_tr,xi);

% OUTPUTS-
% **cohsig7: coherent RBS spectrum using s7 model**
% **cohsig6: coherent RBS spectrum using s6 model**
% **sptsig7: spontaneous RBS spectrum using s7 model**
% **sptsig6: spontaneous RBS spectrum using s6 model**