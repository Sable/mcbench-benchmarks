%  Figure 4.18      Feedback Control of Dynamic Systems, 6e
%                   Franklin, Powell, Emami
%
% script to generate Figure 4.18(a) and 4.18(b)
%
% First, input the plant model and compute the reaction curve.
sysp=tf(1,[600 70 1])
set(sysp,'td', 5)
%Method based on the untimate gain
% in this case, kp = 7.65 for P and
% kp = 6.885 and TI = 35 for PI control
sysdP = tf(7.65,1)
% To get the closed loop response, we must use a pade approximation to the
% delay
syspade=pade(sysp,3);
sysforward=syspade*sysdP;
sysback=tf(1,1)
syscl=feedback(sysforward,sysback)
figure(1)
clf
step(syscl)
title('Figure 4.18a Closed loop responses using Ultimate Period data')
gtext('P')
hold on
%case II, PI control
%kp = 6.885, TI=35
sysdPI=6.885*tf([35 1],[35 0])
sysforward=syspade*sysdPI;
syscl=feedback(sysforward,sysback)
step(syscl)
gtext('PI')
nicegrid;

%
sysdP = tf(7.65/3,1)
% To get the closed loop response, we must use a pade approximation to the
% delay
syspade=pade(sysp,3);
sysforward=syspade*sysdP;
sysback=tf(1,1)
syscl=feedback(sysforward,sysback)
figure(2)
clf
step(syscl)
title('Figure 4.18b Closed loop responses using Ultimate Period data')
gtext('P')
hold on
%case II, PI control
%kp = 6.885, TI=35
sysdPI=(6.885/3)*tf([35 1],[35 0])
sysforward=syspade*sysdPI;
syscl=feedback(sysforward,sysback)
step(syscl)
gtext('PI')
nicegrid;
%
