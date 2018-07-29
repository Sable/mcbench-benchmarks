% By Roger Aarenstrup, roger.aarenstrup@mathworks.com
% 2006-08-18
%
% This is a state-space DC motor model of a
% Maxon RE25 10 Watt, precious metal brushes, 118743
% 
% This model also have a weak connection to a load.
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            The full dc motor model                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Vin is the input voltage to the motor
% i is the motor current
% th_m is the rotor angle, theta
% dth_m is the rotor angular velocity sometimes called omega
% th_l is the load angle
% dth_l is the load angular velocity

% Controller Sample Time
Ts = 100e-6;

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

% SYSTEM MATRICES
%
% States:  [i dth_m th_m dth_l th_l]' 
% Input:   Vin the motor voltage
% Outputs: same as states
%
Afull = [-Rm/Lm    -Kb/Lm       0       0       0;
         Kt/Jm   -(bm+b)/Jm   -Ks/Jm    b/Jm     Ks/Jm;
           0          1         0       0        0;
           0         b/Jl    Ks/Jl   -(b+bl)/Jl    -Ks/Jl;
           0          0         0       1        0];
   
Bfull = [1/Lm 0 0 0 0]';

Cfull = [0 1 0 0 0;
         0 0 1 0 0;
         0 0 0 1 0;
         0 0 0 0 1];

Dfull = [0 0 0 0]';

sys_full = ss(Afull, Bfull, Cfull, Dfull);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     The reduced dc motor model for current control      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% SYSTEM MATRICES
%
% States:  [dth_m th_m dth_l th_l]' 
% Input:   I The current to the dc motor
% Outputs: same as states
%
Ared = [ -(bm+b)/Jm   -Ks/Jm    b/Jm     Ks/Jm;
              1         0       0        0;
             b/Jl    Ks/Jl   -(b+bl)/Jl    -Ks/Jl;
              0         0       1        0];
   
Bred = [Kt/Jm 0 0 0]';

Cred = eye(4);

Dred = [0 0 0 0]';

sys_red = ss(Ared, Bred, Cred, Dred);

% Discrete version of the model (as seen from the controller)
sys_red_d = c2d(sys_red, Ts, 'zoh');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        State-space controller design attempt 1          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The discrete poles of the closed loop system
dpole1 = exp(-2*pi*Ts*[20 22 24 26]);

% Calculate the control parameters
L1 = place(sys_red_d.a, sys_red_d.b, dpole1);

% Keep the static gain of the closed loop system to 1
F=feedback(sys_red_d, L1);   % The closed loop system, F.
Kstatic = freqresp(F, 0);    % Get the static gain of F.
Kstat = 1/Kstatic(4);        % It is the fourth output (load position)

% The above commands requires toolboxes, incase you don't have them
% you can simulate the system with a unit step is see the output static
% gain. Kstat will be the inverse of that.

% to verify the pole placement
%pzmap(F);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  State-space controller design attempt 2 - Integrator   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The discrete poles of the closed loop system
dpole2 = exp(-2*pi*Ts*[20 22 24 26 5]); 

% We only consider one output here
Cred_one = [0 1 0 0];

% Calculate the control parameters
Aint = [sys_red_d.a [0 0 0 0]';
        -Cred_one 1];
   
Bint= [sys_red_d.b' 0]';

Cint = [Cred_one 0];

Dint = [0]';

sys_int_d2 = ss(Aint, Bint, Cint, Dint, Ts);

% Controllability VS Observability analysis
%ob = obsv(sys_int_d2.a, sys_int_d2.c);
%cr = ctrb(sys_int_d2.a, sys_int_d2.b);
%rank(ob)
%rank(cr)

[L2, a, m] = place(sys_int_d2.a, sys_int_d2.b, dpole2);

% Feed Forward gain
Kff = L2(5)/(dpole2(5) - 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  State-space controller design attempt 3 - Observer     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% These should be about twice as fast as the state feedback
% for the controller.
dpole3 = exp(-2*pi*Ts*[1400 1450 1500 1550]);
%dpole3 = [-0.3 -0.33 -0.35 -0.37];

% Recalculate the reduced model with one ouput
Cred2 = [0 1 0 0];

Dred2 = 0;

sys_red2 = ss(Ared, Bred, Cred2, Dred2);

% Discrete version of the model (as seen from the controller)
sys_red_d2 = c2d(sys_red2, Ts, 'zoh');

set(sys_red_d2, 'inputname', {'Um'}, ...
                'outputname', {'Enc_out'});

% Calculate the observer state feedback
K = place(sys_red_d2.a', sys_red_d2.c', dpole3);

% Put the observer together
Aobs = [sys_red_d2.a-K'*sys_red_d2.c];
Bobs = [sys_red_d2.b K'];
Cobs = eye(4);
Dobs = [0 0 0 0; 0 0 0 0]';

observer = ss(Aobs, Bobs, Cobs, Dobs, Ts, 'inputname', {'Ue', 'Enc_in'}, ...
              'outputname', {'dth_m', 'th_m', 'dth_l', 'th_l'});


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  State-space controller design attempt 4 - The Servo Case  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Kinv = (Jl+Jm)/Kt;

dpole4 = exp(-2*pi*Ts*[200 204 220 224 300]);
[L3, a, m] = place(sys_int_d2.a, sys_int_d2.b, dpole4);





