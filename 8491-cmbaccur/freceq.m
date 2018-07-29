function  dyda = freceq(a, xe, om, omb, omt, h)
% function for the recombination equation in the recombination process of a H-atom:
% the integration variable is the scale factor a.
% the output dyda is a column vector of two derivatives :
% 1. the derivative of the free electron fraction to the scale factor a : d(xe)/da 
% 2. the derivative of the matter temperature (tm in degr K) to the scale factor a : d(tm)/da 
% further inputs : om is the matter denisty, omb is the baryon density and h the Hubble factor,
% omt, curvature density of the universe.
% The aim is to calculate xe, the free electron fraction, before and during recombination as f of a.
% see S. Seager,..ApJ nr 128, 407 (2000) eq (1)(3) and (5)
%
% D Vangheluwe 19 nov 2004
% remark 1: take attention that tm == xe(2) and xe = xe(1)
% remark 2: changed fv following wmap data from 0.405 t0 0.412 : this gives ka1 = 4.21e-5
% remark 3: modified for curvature of space with extra input omt (dd 31 mrt 2005)

global  GL_cmb_c  GL_cmb_t0  GL_cmb_ncr  GL_cmb_pcm  GL_cmb_yp  GL_cmb_fv GL_cmb_kg1  GL_cmb_ka1  GL_cmb_cr;

% velocity of light in m/s
c = GL_cmb_c;
% temperature of the CMB now in degr K and in eV
t0 = GL_cmb_t0;
% recombination energy to 2s-(2p)-level in hydrogen in m and eV : e2s = 10.1984 eV;
lambda_h2p = 121.5682e-9;
%e2s = 1.2398e-6/lambda_h2p;
e2s = 10.1987;
% energy of the excited states of the hydrogen atom in eV
e2c = 3.395;
% electron mass in eV
me = 0.5109989 * 1e6;
% proton mass in eV
mp = 938.272e6;
% critical concentration and mass density of baryons in m^-3 resp eVm^-3
%ncr = 11.23;
ncr = GL_cmb_ncr;
dcr = ncr * h^2 * mp/om;
% hstreep-c (PLanck constant) in eVm
hc = 1.9733e-7;
% conversion of Parsec to meters
%pcm = 3.0856e22;
pcm = GL_cmb_pcm;
% two photon rate lambda_h in sec^-1
lambda_h = 8.22458;
% the He abundance fraction
%yp = 0.24;
yp = GL_cmb_yp;
% the ratio of neutrino to total radiation density fv, assuming three massless neutrinos
% changed following wmap data from 0.405 to 0.408
%fv = 0.405;
fv = GL_cmb_fv;
% radiation density/critical density (radiation constant?)
%rd = 2.47e-5;
rd = GL_cmb_kg1;
%gv = 1 + (21/8)*(4/11)^(4/3);
%fv = 1 - 1/gv;
%ka1 = rd/(1-fv);
%ka1 = rd *gv;
ka1 = GL_cmb_ka1;
% compton cross section in m^2, see Dodelson p 72
%cr = 0.665e-28;
cr = GL_cmb_cr;

tm = xe(2);
tr = t0/a;
tev = tm/11605; 
% calculate the coefficient of xe^2 in the dvd reaction equation, see Seager formula (1)(3)
alpha_h = 1.14*1e-19 * 4.309 * (tm/1e4)^(-0.6166)/(1 + 0.6703 * (tm/1e4)^(0.530));
% n_h is the number density of the protons at the start of the recombination (they finish as Hatoms) :
% the fraction to make Helium atoms should be sustracted from the critical number 
n_h = (1 - yp) *omb * h^2 * ncr/a^3;
beta_h = (1/hc^3) * (me * tev/(2*pi))^1.5 * exp(-e2c/tev);
% hubble factor in sec^-1 : take the flat model with cosmological constant and including radiation
%ha = 1e5/(pc_m * a^2) * sqrt(dr_dcr/2);
ha = (1e5 * h/pcm) * sqrt(om/a^3 + ka1/ (h^2 * a^4) + (omt - om - ka1/h^2) + (1 - omt)/a^2);
klambda = lambda_h2p^3 /(8 * pi * ha);
xcoef = (1 + klambda * lambda_h * n_h * (1 - xe(1)))/ ...
        (1 + klambda * (lambda_h + alpha_h * beta_h) * n_h * (1 - xe(1)));

tcoef = (8* c* cr * rd * (dcr/h^2)/ a^4)/(3* me * ha);

dyda1 = -[n_h * xe(1)^2 - beta_h *(1 - xe(1))* exp(-e2s/tev)] * (alpha_h/(ha * a)) .* xcoef;
dyda2 = -[tcoef * xe(1)/(1 + yp + xe(1)) * (tm - tr) + 2* tm]/a;
dyda = [dyda1 ; dyda2];
%dyda = dyda1;



