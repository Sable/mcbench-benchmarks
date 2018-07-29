function TAU = int_tau(Z)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Program:    Tau Integral Computation for Hydrogen Composition Program
%               in Atmospheric Model
%   Author:     Brent Lewis(RocketLion@gmail.com)
%               University of Colorado-Boulder
%   History:    Original-1/10/2007
%   Input:      Z:      Altitude value
%   Output:     TAU:    Integral Value
%   Note:       This program computes the value of Tau directly with the
%               integral done by hand and only the second integration limit
%               needing to be inputed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   Constants
L_K_9 = 12;
T_10 = 360;
T_inf = 1000;
Z_10 = 120;
g_0 = 9.80665;
r_E = 6.356766e3;
R = 8.31432e3;
lambda = L_K_9/(T_inf-T_10);
M_H = 1.00797;

%   Value of Integration limit computed previously
tau_11 = 8.329503912749350e-004;

tau_Z = M_H*g_0*r_E^2/R*...
    log((exp(lambda*(Z-Z_10)*(r_E+Z_10)/(r_E+Z))-1)*T_inf+T_10)/...
    (lambda*T_inf*(r_E+Z_10)^2);

TAU = tau_Z-tau_11;