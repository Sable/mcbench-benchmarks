% Electric vehicle model
% Created by John Hedengren, john_hedengren@hotmail.com

% Based on dc motor model
%   by Roger Aarenstrup, roger.aarenstrup@mathworks.com
%
function xdot=electric_car(t,x)

global u

% Vin is the input voltage to the motor (Volts)
% i is the motor current (Amps)
% dth_m is the rotor angular velocity sometimes called omega (radians/sec)
% th_m is the rotor angle, theta (radians)
% dth_l is the wheel angular velocity (rad/sec)
% th_l is the wheel angle (radians)
% dth_v is the vehicle velocity (m/sec)
% th_v is the distance travelled (m)

% Input:   Vin: motor voltage
Vin = u;

% Motor parameters (DC motor)
Rm  = 0.1;             % Motor resistance (ohm)
Lm  = 0.01;             % motor inductance (Henrys)
Kb = 6.5e-4;           % Back EMF constant (Volt-sec/Rad)
Kt = 0.1;            % Torque constant (Nm/A)
Jm = 1.0e-4;           % Rotor inertia (Kg m^2)
bm = 1.0e-5;           % Mechanical damping (linear model of
                        % friction: bm * dth)
% Automobile parameters
Jl = 1000*Jm;   % Vehicle inertia (1000 times the rotor)
bl = 1.0e-3;    % Vehicle damping (friction)
K = 1.0e2;      % Spring constant for connection rotor/drive shaft
b = 0.1;        % Spring damping for connection rotor/drive shaft
rl = 0.005;     % gearing ratio between motor and tire (meters travelled
                %  per radian of motor rotation)
tau = 2;        % time constant of a lag between motor torque and car
                %   velocity.  This lag is a simplified model of the power
                %   train. (sec)

% States:  [i dth_m th_m dth_l th_l dth_v th_v]' 
%
A = [-Rm/Lm    -Kb/Lm       0       0       0         0 0;
     Kt/Jm   -(bm+b)/Jm   -K/Jm    b/Jm     K/Jm      0 0;
       0          1         0       0        0        0 0;
       0         b/Jl    K/Jl   -(b+bl)/Jl -K/Jl      0 0;
       0          0         0       1        0        0 0;
       0          0         0      rl/tau    0   -1/tau 0;
       0          0         0       0        0        1 0];
   
B = [1/Lm 0 0 0 0 0 0]';

xdot = A * x + B * u;

end