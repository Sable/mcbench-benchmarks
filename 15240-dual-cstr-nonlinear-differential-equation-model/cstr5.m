% Nonlinear model of two CSTRs in series from
%
% Henson, M.A. and Seborg, D.E., Feedback Linearizing Control, Chap. 4 of Nonlinear Process
%   Control, Edited by Hensen, M.A. and Seborg, D.E., Prentice Hall (1997)
%
%  t -- time (not used)
%  y -- state value vector
%  xdot -- set to the vector of state derivatives

function xdot = cstr5(t,y)

global u

% Input (1):
% Coolant Flowrate (L/min)
qc = u;

% States (4):
% Concentration of A in Reactor #1 (mol/L)
Ca1 = y(1);
% Temperature of Reactor #1 (K)
T1 = y(2);
% Concentration of A in Reactor #2 (mol/L)
Ca2 = y(3);
% Temperature of Reactor #2 (K)
T2 = y(4);

% Parameters
% Flowrate (L/min) 
q = 100;
% Feed Concentration of A (mol/L)
Caf = 1.0;
% Feed Temperature (K)
Tf	= 350.0 ;
% Coolant Temperature (K)
Tcf = 350.0;
% Volume of Reactor #1 (L)
V1 = 100;
% Volume of Reactor #2 (L)
V2 = 100;
% UA1 or UA2 - Overall Heat Transfer Coefficient (J/min-K)
UA1 = 1.67e5;
UA2 = 1.67e5;
% Pre-exponential Factor for A->B Arrhenius Equation
k0 = 7.2e10;
% EoverR - E/R (K) - Activation Energy (J/mol) / Gas Constant (J/mol-K)
EoverR = 1e4;
% Heat of Reaction - Actually (-dH) for an exothermic reaction (J/mol)
dH = 4.78e4;
% Density of Fluid (g/L)
rho = 1000;
% Density of Coolant Fluid (g/L)
rhoc = 1000;
% Heat Capacity of Fluid (J/g-K)
Cp = 0.239;
% Heat Capacity of Coolant Fluid (J/g-K)
Cpc = 0.239;

%	Dynamic Balances
 
%	dCa1/dt
xdot(1,1) = q*(Caf-Ca1)/V1 - k0*Ca1*exp(-EoverR/T1);
%	dT1/dt
xdot(2,1) = q*(Tf-T1)/V1 + (dH*k0/rho/Cp)*Ca1*exp(-EoverR/T1) + ...
   rhoc*Cpc/rho/Cp/V1 * qc * (1-exp(-UA1/qc/rhoc/Cpc)) * (Tcf-T1);
%	dCa2/dt
xdot(3,1) = q*(Ca1-Ca2)/V2 - k0*Ca2*exp(-EoverR/T2);
%	dT2/dt
xdot(4,1)  = q*(T1-T2)/V2 + (dH*k0/rho/Cp)*Ca2*exp(-EoverR/T2) + ...
   rhoc*Cpc/rho/Cp/V2 * qc * (1-exp(-UA2/qc/rhoc/Cpc)) * ...
   (T1 - T2 + exp(-UA1/qc/rhoc/Cpc)*(Tcf-T1));

