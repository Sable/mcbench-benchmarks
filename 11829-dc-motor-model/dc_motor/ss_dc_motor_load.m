% By Roger Aarenstrup, roger.aarenstrup@mathworks.com
% 2006-07-30
%
% This is a state-space DC motor model of a
% Maxon RE25 10 Watt, precious metal brushes, 118743
% 
% This model also have a weak connection to a load.
%

% Vin is the input voltage to the motor
% i is the motor current
% th_m is the rotor angle, theta
% dth_m is the rotor angular velocity sometimes called omega
% th_l is the load angle
% dth_l is the load angular velocity

% PARAMETERS DC MOTOR
Rm  = 2.06;             % Motor resistance (ohm)
Lm  = 0.000238;         % motor inductance (Henrys)
Kb = 1/((406*2*pi)/60); % Back EMF constant (Volt-sec/Rad)
Kt = 0.0235;            % Torque constand (Nm/A)
Jm = 1.07e-6;           % Rotor inertia (Kg m^2)
bm = 12e-7;             % MEchanical damping (linear model of
                        % friction: bm * dth)
% PARAMETERS LOAD
Jl = 10*Jm;   % Load inertia (10 times the rotor)
bl = 12e-6;   % Load damping (friction)
K = 100;      % Spring constant for connection rotor/load
b = 0.0001;   % Spring damping for connection rotor/load

% SYSTEM MATRICES
%
% States:  [i dth_m th_m dth_l th_l]' 
% Input:   Vin the motor voltage
% Outputs: same as states
%
Al = [-Rm/Lm    -Kb/Lm       0       0       0;
     Kt/Jm   -(bm+b)/Jm   -K/Jm    b/Jm     K/Jm;
       0          1         0       0        0;
       0         b/Jl    K/Jl   -(b+bl)/Jl    -K/Jl;
       0          0         0       1        0];
   
Bl = [1/Lm 0 0 0 0]';

Cl = eye(5);

Dl = [0 0 0 0 0]';

%sys_load = ss(Al, Bl, Cl, Dl);