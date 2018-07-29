% CSTR model from
%
% Michael A. Henson and Dale E. Seborg.  Nonlinear Process Control.
%      Prentice Hall PTR, Upper Saddle River, New Jersey, 1997.

% Description:
% Continuously Stirred Tank Reactor with energy balance and reaction A->B.
%   The temperature of the cooling jacket is the control.

function xdot=cstr1(t,x)

global u

% Input (1):
% Temperature of cooling jacket (K)
Tc = u;

% States (2):
% Concentration of A in CSTR (mol/m^3)
Ca = x(1,1);
% Temperature in CSTR (K)
T = x(2,1);

% Parameters:
% Volumetric Flowrate (m^3/sec)
q = 100;
% Volume of CSTR (m^3)
V = 100;
% Density of A-B Mixture (kg/m^3)
rho = 1000;
% Heat capacity of A-B Mixture (J/kg-K)
Cp = .239;
% Heat of reaction for A->B (J/mol)
mdelH = 5e4;
% E - Activation energy in the Arrhenius Equation (J/mol)
% R - Universal Gas Constant = 8.31451 J/mol-K
EoverR = 8750;
% Pre-exponential factor (1/sec)
k0 = 7.2e10;
% U - Overall Heat Transfer Coefficient (W/m^2-K)
% A - Area - this value is specific for the U calculation (m^2)
UA = 5e4;
% Feed Concentration (mol/m^3)
Caf = 1;
% Feed Temperature (K)
Tf = 350;

% Compute xdot:
xdot(1,1) = (q/V*(Caf - Ca) - k0*exp(-EoverR/T)*Ca);
xdot(2,1) = (q/V*(Tf - T) + mdelH/(rho*Cp)*k0*exp(-EoverR/T)*Ca + UA/V/rho/Cp*(Tc-T));