function  eta = conftim1(a, om, omr, omt, h)
% calculate the conformal time today for a universe with a cosmological constant
% oml = ratio of dark energy and matter = ohm_l/ohm_m
%
% D Vangheluwe 2 oct 2004
% modified for curvature of space with extra variable : omt (dd 31 mrt 2005)

global  GL_cmb_c  GL_cmb_h0;

% velocity of light in m/s
%c = 2.998e8;
c = GL_cmb_c;
% the hubble constant at present in h Mpc^-1, see my notes p71
%h0 = 1e5/c;
h0 = GL_cmb_h0;

eta = 1 ./ (h0 * h * sqrt(omr + om * a + (omt - omr - om) * a.^4 + (1 - omt) * a.^2));
