%% series_shunt amplifier parameters
% Dick Benson
% Copyright 2004-2013 The MathWorks, Inc.


clear 
clc
% Transistor Parameters for Ebbers-Moll Model
IEs = 1e-12; 
ICs = IEs;
Cbc = 10e-12;
Cbe = 250e-12;
Rbb = 5;
Beta = 100;
Base_Bias=0.8;
Tau_Junction = 100e-12;

% Amplifier parameters 
Gdb = 16;      % desired power gain
Av = 10^(Gdb/20)
Pout = 3.16;   % Desired Peak Watts 
Vcc  = 12;     % Supply Volts
Tr   = 1/3     % transformer turns ratio (1/2 secondary)
Rl   = 2*(50*Tr^2)% ohms
Rin  = Rl;
% Pout = (Vcc/Head_Room)^2/Rl
Head_Room=Vcc/sqrt(Rl*Pout)   % needs to be > 1, the more the better for IMD
Rfb=Rl*(1*Av+1)
Re = (Rl^2)/Rfb

% transformer design
Zo=50;
K = 0.995
Rloss = .1;
Tr_1 = 1/sqrt(Zo/(Rl/2))
Lpri_1 = 5e-6;
Lsec_1 = Lpri_1*Tr_1^2;
M12_1  = K*Tr_1*Lpri_1;
M13_1  = M12_1;
M23_1 =  K*Lsec_1;


