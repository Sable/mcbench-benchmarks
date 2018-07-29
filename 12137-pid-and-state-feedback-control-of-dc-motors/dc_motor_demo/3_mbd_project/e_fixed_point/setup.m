%% 
addpath('controller_component');
addpath('traj_gen_component');

%% Controller specific parameters
Ts = 0.0001;

%% Load component parameters
controller_params;
traj_gen_params;

%% Plant model parameters
% PARAMETERS DC MOTOR
Rm  = 2.06;             % Motor resistance (ohm)
Lm  = 0.000238;         % motor inductance (Henrys)
Kb = 1/((406*2*pi)/60); % Back EMF constant (Volt-sec/Rad)
Kt = 0.0235;            % Torque constand (Nm/A)
Jm = 1.07e-6;           % Rotor inertia (Kg m^2)
bm = 12e-7;             % MEchanical damping (linear model of
                        % friction: bm * dth)
% PARAMETERS LOAD
Jl = 10.07e-6;   % Load inertia (10 times the rotor)
bl = 12e-6;      % Load damping (friction)
Ks = 100;        % Spring constant for connection rotor/load
b = 0.0001;      % Spring damping for connection rotor/load
