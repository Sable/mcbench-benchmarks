% Simulation and Virtual Reality Parameters

% Simulation Parameters
TS = 0.001;							% base sample rate [sec]
PWM_BL = 99;						% pwm value to detect backlash [%]

% simulation stops when TIME_STOP_SIM have passed after NXT SCARA stopped
TIME_STOP_SIM = 10 * 1e3;			% simulation stop threshold [msec]

% proportional gain to calculate pen height from pwm3 value
PEN_HEIGHT_VEC = 60 / (pwm3_pen * time_pwm3 * TS);
									
% Virtual Reality Parameters
TS_VR = 0.5;						% VRML refresh rate [sec]
ROT_AXIS_Y = [0, 1, 0];				% rotation axis along y axis
