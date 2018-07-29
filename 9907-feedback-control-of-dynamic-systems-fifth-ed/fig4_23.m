%Figure 4.23       Feedback Control of Dynamic Systems, 5e
%                      Franklin, Powell, Emami
%
% script to generate Figure 4.22, 4.23, and 4.25
% case I, P control by reaction curve data.
% First, input the plant model and compute the reaction curve.
sysp=tf(1,[600 70 1])
set(sysp,'InputDelay', 5)
figure(1)
clf
step(sysp)
title('Figure 4.22 Reaction Curve for the Heat Exchanger')
grid on
pause;
% From the curve, kp = 6.92 for proportional control
sysdP = tf(6.92,1)
% To get the closed loop response, we must use a pade aproximany to the
% delay
syspade=pade(sysp,3);
sysforward=syspade*sysdP;
sysback=tf(1,1)
syscl=feedback(sysforward,sysback)
figure(2)
clf
step(syscl)
title('Figure 4.23a Closed loop response using Reaction Curve data')
gtext('P')
hold on
pause;
%case II, PI control
%kp = 6.22, TI=43.3
sysdPI=6.22*tf([43.3 1],[43.3 0])
sysforward=syspade*sysdPI;
syscl=feedback(sysforward,sysback)
step(syscl)
gtext('PI')
grid on
pause;
%
sysdP = tf(6.92/3,1)
% To get the closed loop response, we must use a pade aproximany to the
% delay
syspade=pade(sysp,3);
sysforward=syspade*sysdP;
sysback=tf(1,1)
syscl=feedback(sysforward,sysback)
figure(3)
clf
step(syscl)
title('Figure 4.23b Closed loop response using Reaction Curve data')
gtext('P')
hold on
pause;
%case II, PI control
%kp = 6.22, TI=43.3
sysdPI=(6.22/3)*tf([43.3 1],[43.3 0])
sysforward=syspade*sysdPI;
syscl=feedback(sysforward,sysback)
step(syscl)
gtext('PI')
grid on
pause;
%
%Method based on the untimate gain
% in this case, kp = 7.65 for P and
% kp = 6.885 and TI = 35 for PI control
sysdP = tf(7.65,1)
% To get the closed loop response, we must use a pade aproximany to the
% delay
syspade=pade(sysp,3);
sysforward=syspade*sysdP;
sysback=tf(1,1)
syscl=feedback(sysforward,sysback)
figure(4)
clf
step(syscl)
title('Figure 4.25a Closed loop responses using Ultimate Period data')
gtext('P')
hold on
%case II, PI control
%kp = 6.885, TI=35
sysdPI=6.885*tf([35 1],[35 0])
sysforward=syspade*sysdPI;
syscl=feedback(sysforward,sysback)
step(syscl)
gtext('PI')
grid on
pause;
%
sysdP = tf(7.65/3,1)
% To get the closed loop response, we must use a pade aproximany to the
% delay
syspade=pade(sysp,3);
sysforward=syspade*sysdP;
sysback=tf(1,1)
syscl=feedback(sysforward,sysback)
figure(5)
clf
step(syscl)
title('Figure 4.25b Closed loop responses using Ultimate Period data')
gtext('P')
hold on
%case II, PI control
%kp = 6.885, TI=35
sysdPI=(6.885/3)*tf([35 1],[35 0])
sysforward=syspade*sysdPI;
syscl=feedback(sysforward,sysback)
step(syscl)
gtext('PI')
grid on
%

