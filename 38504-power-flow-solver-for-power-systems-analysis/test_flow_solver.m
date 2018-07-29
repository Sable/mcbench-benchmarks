% Example of use for function 'power_flow_solver'.
% Written by Dr. Yoash Levron, October 2012.
%
% All documentation may be obtained by typing:
% 'HELP power_flow_solver' at the matlab command prompt.
%
% This script defines a simple power network
% and uses the 'power_flow_solver' function to
% compute the power flow in it.
%
% Associated file: 'power_flow_solver.m'


%%%%%%% Define the network  %%%%%%%
% The network composes three buses.
% bus 1 - (slack bus) a voltage source, E=1.0
% bus 2 - a generator and a load.
% bus 3 - a load.
%
% Define the line impedances:
z12 = 0.05 + j*0.1;  % impedance (inductive) connecting bus 1 to 2.
z13 = 0.02 + j*0.05; % impedance (inductive) connecting bus 1 to 3.
z23 = j*0.05; % impedance (inductive) connecting bus 2 to 3.
z11 = -j*100;  % shunt impedance (capacitive) at bus 1
z22 = inf;  % no shunt impedance at bus 2
z33 = -j*40;  % shunt impedance (capacitive) at bus 3

% A matrix of the network impedances
Zmat = [z11 z12 z13;
        z12 z22 z23;
        z13 z23 z33];

% compute the admittance matrix (admittamce = 1/impedance):
Ymat = 1./Zmat;

% Define voltage at bus 1
E1_phase = 0; % degree (reference phase angle).
E1_mag = 1.0; % voltage magnitude
E1 = E1_mag*exp(j*E1_phase*(pi/180));

% Define generators and loads.
% Pg&Qg - generators.   Pl&Ql - loads.
Pg1=0;  Qg1=0; Pl1=0; Ql1=0; % no power source on the slack bus.
Pg2=2;  Qg2=0;  Pl2=1; Ql2=1;  % bus 2. generator and load.
Pg3=0;  Qg3=0;  Pl3=3; Ql3=0.5; % bus 3. a load.

% sum generators and load to form united power sources.
% (generators taken positive, loads taken negative).
P1 = Pg1 - Pl1;
P2 = Pg2 - Pl2;
P3 = Pg3 - Pl3;
Q1 = Qg1 - Ql1;
Q2 = Qg2 - Ql2;
Q3 = Qg3 - Ql3;

% Define power vectors:
Pbus = [P1 P2 P3];
Qbus = [Q1 Q2 Q3];

% run function to solve the power flow
[Ebus, Ibus, Imat, iter] = ...
    power_flow_solver(Ymat, Pbus, Qbus, E1);

% display results
clc;
disp('---  SUMMARY OF RESULTS  ---');
disp('number of iterations until convergence:');
disp(iter);
disp('voltage magnitudes');
disp(abs(Ebus.'));
disp('voltage phase angles (degree)');
disp(phase(Ebus.')*180/pi);
disp('current supplied by each source (amplitude)');
disp(abs(Ibus.'));
disp('Active power supplied by each source');
disp(real(Ebus.*conj(Ibus)));
disp('Reactive power supplied by each source');
disp(imag(Ebus.*conj(Ibus)));
disp('current in bus 1 --> bus 2');
disp(Imat(1,2));
disp('current in bus 1 --> bus 3');
disp(Imat(1,3));
disp('current in bus 2 --> bus 3');
disp(Imat(2,3));
disp('shunt currents in each bus (magnitude)');
disp(abs(diag(Imat).'));



