%  Figure 4.16      Feedback Control of Dynamic Systems, 6e
%                   Franklin, Powell, Emami
%% script to generate Figure 4.16(a), 4.16 (b)
% case I, P control by reaction curve data.
% First, input the plant model and compute the reaction curve.
sysp=tf(1,[600 70 1])
set(sysp,'td', 5)

% From the curve, kp = 6.92 for proportional control
sysdP = tf(6.92,1)
% To get the closed loop response, we must use a pade approximation to the
% delay
syspade=pade(sysp,3);
sysforward=syspade*sysdP;
sysback=tf(1,1)
syscl=feedback(sysforward,sysback)
figure(1)
clf
step(syscl)
title('Figure 4.16a Closed loop response using Reaction Curve data')
gtext('P')
hold on
%case II, PI control
%kp = 6.22, TI=43.3
sysdPI=6.22*tf([43.3 1],[43.3 0])
sysforward=syspade*sysdPI;
syscl=feedback(sysforward,sysback)
step(syscl)
gtext('PI')
nicegrid
%
sysdP = tf(6.92/3,1)
% To get the closed loop response, we must use a pade approximation to the
% delay
syspade=pade(sysp,3);
sysforward=syspade*sysdP;
sysback=tf(1,1)
syscl=feedback(sysforward,sysback)
figure(2)
clf
step(syscl)
title('Figure 4.16b Closed loop response using Reaction Curve data')
gtext('P')
hold on
%case II, PI control
%kp = 6.22, TI=43.3
sysdPI=(6.22/3)*tf([43.3 1],[43.3 0])
sysforward=syspade*sysdPI;
syscl=feedback(sysforward,sysback)
step(syscl)
gtext('PI')
nicegrid;
