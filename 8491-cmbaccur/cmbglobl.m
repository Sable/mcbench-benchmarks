% cmbglobl.m : cmb globals : physical constants that are used through all files
% are given a value here
%
% D Vangheluwe 28 jan 2005, see cmbaccur.m anc cmbacc1.m as the main files

global  GL_cmb_c GL_cmb_h0  GL_cmb_t0  GL_cmb_T0  GL_cmb_rv  GL_cmb_fv  GL_cmb_kg1  GL_cmb_ka1 ...
  GL_cmb_yp  GL_cmb_ncr  GL_cmb_cr  GL_cmb_pcm  GL_cmb_dha;
 
% velocity of light in m/s
GL_cmb_c = 2.998e8;
% the Hubble constant at present in (h Mpc^-1), see my notes p71
GL_cmb_h0 = 1e5/GL_cmb_c;
% the present temperature of the CMB in degr Kelvin and in eV
GL_cmb_t0 = 2.725;
GL_cmb_T0 = GL_cmb_t0/11605;
% ratio of radiation density/critical density, see Dodelson (2.87)
%fv = 0.405;
GL_cmb_rv = (21/8) * (4/11)^(4/3);
GL_cmb_fv = GL_cmb_rv/(1 + GL_cmb_rv);
GL_cmb_kg1 = 2.47e-5;
GL_cmb_ka1 = GL_cmb_kg1/(1 - GL_cmb_fv);
%ka1 = 4.15e-5;
% the primordial helium mass fraction
GL_cmb_yp = 0.24;
% critical density in m^-3
GL_cmb_ncr = 11.23;
%ncr = 10.8;
% Compton cross section in m^2, see Dodelson p 72
GL_cmb_cr = 0.665e-28;
% conversion of Parsec to meters
GL_cmb_pcm = 3.0856e22;
% amplitude of the primordial density perturbation at the horizon, see Dodelson (8.76)
GL_cmb_dha = 4.47e-5;

