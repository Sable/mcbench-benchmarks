% By Roger Aarenstrup, roger.aarenstrup@mathworks.com
% 2006-07-30
%
% This is a state-space DC motor model of a
% Maxon RE25 10 Watt, precious metal brushes, 118743
% 
% This model models the dc motor only. You can change
% the inertia and mechanical damping to add a rigid load.
%

% Vin is the input voltage to the motor
% i is the motor current
% th is the rotor angle, theta
% dth is the rotor angular velocity sometimes called omega


% PARAMETERS
Rm  = 2.06;             % Motor resistance (ohm)
Lm  = 0.000238;         % motor inductance (Henrys)
Kb = 1/((406*2*pi)/60); % Back EMF constant (Volt-sec/Rad)
Kt = 0.0235;            % Torque constand (Nm/A)
Jm = 1.07e-6;           % Rotor inertia (Kg m^2)
bm = 12e-7;             % MEchanical damping (linear model of
                        % friction: bm * dth)

% SYSTEM MATRICES
%
% States:  [i dth th]' 
% Input:   Vin the motor voltage
% Outputs: same as states
%
% Note that the last state, dth, can be removed in many cases
% when the actual angle is not needed.
%
A = [-Rm/Lm   -Kb/Lm   0;
      Kt/Jm   -bm/Jm   0;
        0        1     0];
   
B = [1/Lm 0 0]';

C = [1 0 0; 0 1 0; 0 0 1];

D = [0 0 0]';

% CONTROL SYSTEM TOOLBOX ------------------------------------
% If you don't have it, please remove or comment the lines
% below, or call your local sales rep. ;)

% Create a ss object of the model
sys = ss(A, B, C, D);

% EXAMPLE: CONVERT TO TRANSFER FUNCTION
% Gen the transferfunctions of the system (3 of them, one
% for each output).
[num den] = ss2tf(sys.a, sys.b, sys.c, sys.d, 1);

% Create a transfer function object for the angular veclocity
% dth = G(s) Vin
G = tf(num(2,:), den)

% NOTE! Transfer functions are not suitable for calculations
% in MATLAB becasue the numerical algorithms for transfer
% functions are inaccurate. For small systems, like this, with
% only three states it is probably ok but for larget systems
% and very stiff systems numerical problems may arrise.
% Numerical state-space algorithms are a lot more reliable
% so it is generally recommeded to use the state-space form
% during computations.
% In Simulink, however, it is OK to use transfer function
% blocks because they have internally a state-space 
% representation. A drawback, using transfer function blocks,
% is that you can not control initial conditions and you
% can't observe the initial states.

% EXAMPLE: REMOVE ANGLE STATE

% Remove the angle state, the third state
elim = boolean([0 0 1]');
sys_red = modred(sys, elim);

% step(sys_red*12)
% bode(sys_red)
% pzmap(sys_red)
% or simpler
ltiview(sys_red)
figure;
ltiview(sys)
