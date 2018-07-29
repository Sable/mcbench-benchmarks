%% Define plant transfer function
clc;
s=tf('s');
sys=exp(-s*0.2)/(3*s+1)/(3*s+1)
%% Define pid controller as a tf
clc;
Kp=0.2;
Ki=0.5;
Kd=0.3;
c=Kp+Ki/s+Kd*s
%% Define as a pid object
clc;
c=pid(Kp,Ki,Kd)
%% Look at gains
% c.Kp
% c.Ki
%% Start with a proportional controller with a gain of 2
clc;
c=pid(2)
step(1,1); hold on; axis([0 20 0 1.5]);
step(feedback(c*ss(sys),1));
% increase gain to 7 or 8
%% Add integral term to bring steady-state error to zero
% Reduce proportinal gain to 2 to minimize overshoot
clc;
close all;
c=pid(2,0.4)
step(1,1); hold on; axis([0 20 0 1.3]);
step(feedback(c*ss(sys),1),'r');
% look at rise time
%% Add derivative term to increase stability
clc;
c=pid(2,0.4,1.2)
step(feedback(ss(c*sys),1),'c');
clc;

% Copyright 2013 The MathWorks, Inc
