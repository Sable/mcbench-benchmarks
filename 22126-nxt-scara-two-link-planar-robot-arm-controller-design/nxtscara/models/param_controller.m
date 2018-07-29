% Controller Parameters 

% Number of Operation Mode & Motor
num_mode = 2;							% number of operation mode
num_motor = 3;							% number of motor

% Task Sample Rates
ts1 = 50;								% ts1 sample time [msec]
ts2 = 100;								% ts2 sample time [msec]
ts3 = 200;								% ts3 sample time [msec]

% Times
time_wait = 10 * ts1;					% time to wait [msec]
time_pwm3 = 30 * ts1;					% time to run motor3 [msec]
time_pen = 2 * time_wait + time_pwm3;	% time to bring up/down pen [msec]

% PWMs
pwm1_adjst = 50;						% motor1 pwm value for position adjustment [%]
pwm2_adjst = 50;						% motor2 pwm value for position adjustment [%]
pwm3_adjst = 50;						% motor3 pwm value for position adjustment [%]
pwm3_pen = 50;							% motor3 pwm value to bring up/down pen [%]

% Motor Angle Initial Value
[theta1_iv, theta2_iv] = xy2theta(l1 + l2, 0, l1, l2);
theta1m_iv = g1 * theta1_iv;			% motor1 angle initial value [deg]
theta2m_iv = g2 * theta2_iv;			% motor2 angle initial value [deg]

% Motor Angle Limitations
theta1_max = 90;						% maximum angle1 [deg]
theta2_max = 140;						% maximum angle2 [deg]
theta1m_max = g1 * theta1_max;			% maximum motor1 angle [deg]
theta2m_max = g2 * theta2_max;			% maximum motor2 angle [deg]

% Gear Backlash/Engage Parameters
backlash1 = 440;						% gear1 backlash compensation value [deg]
backlash2 = 140;						% gear2 backlash compensation value [deg]
engage1_iv = 1;							% gear1 initial engage state (1/-1: positive/negative direction)
engage2_iv = 1;							% gear2 initial engage state (1/-1: positive/negative direction)
time_en1 = 800;							% gear1 time to engage (time to remove gear1 backlash) [msec]
time_en2 = 600;							% gear2 time to engage (time to remove gear2 backlash) [msec]
dthetam_bl = 3;							% motor angle variation threshold to detect backlash [deg]

% Sound Parameters
sound_freq_mode_chg = 440;				% mode change sound frequency [Hz]
sound_dur_mode_chg = 600;				% mode change sound duration [msec]
sound_freq_motor_chg = 880;				% motor change sound frequency [Hz]
sound_dur_motor_chg = 200;				% motor change sound duration [msec]

clear theta1_iv theta2_iv
