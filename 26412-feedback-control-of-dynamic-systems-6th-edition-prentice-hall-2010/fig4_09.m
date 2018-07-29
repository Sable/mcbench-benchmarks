%  Figure 4.9      Feedback Control of Dynamic Systems, 6e
%                   Franklin, Powell, Emami
% Figure 4.9   PID control of motor speed
% function [np, dp]= pid(b,J,K,L,R,kp,ki,kd)
% function to compute the equations of a d.c. motor with inductance.
% and compute the response under control
clf;
K=.0670; L1=0.1; J1=0.0113; R=0.45; b=0.0280;
kp=3; ki= 15; kd=0.3;
np=K;
dp=[L1*J1 R*J1+b*L1 R*b+K*K];
dclp=[L1*J1 R*J1+b*L1 R*b+K*K+K*kp];
nclp=K*kp;
nclpw=[L1 R];
dclpi=[L1*J1 R*J1+b*L1 R*b+K*K+K*kp K*ki];
nclpi=[K*kp K*ki];
nclpiw=[L1 R 0];
dclpid=[  L1*J1 R*J1+b*L1+K*kd R*b+K*K+K*kp K*ki];
nclpid=[K*kd K*kp K*ki];
nclpidw=[L1 R 0];
sysp=tf(nclp,dclp);
syspw=tf(nclpw,dclp);
syspi=tf(nclpi,dclpi);
syspiw=tf(nclpiw,dclpi);
syspid=tf(nclpid,dclpid);
syspidw=tf(nclpidw,dclpid);
figure(1)
t=0:.01:6;
[y1w,t]=step(syspw,t);
[y2w,t]=step(syspiw,t);
[y3w,t]=step(syspidw,t);
plot(t,y1w,t,y2w,t,y3w);
xlabel('Time (msec)');
ylabel('Amplitude');
title('Fig. 4.9(a) Response of P,PI, and PID control to a disturbance step')
gtext('P')
gtext('PI')
gtext('PID')
nicegrid;

figure(2)
[y1,t]=step(sysp,t);
[y2,t]=step(syspi,t);
[y3,t]=step(syspid,t);
plot(t,y1,t,y2,t,y3);
xlabel('Time (msec)');
ylabel('Amplitude');
title('Fig. 4.9 (b) Response of P,PI, and PID control to a reference step')
gtext('P')
gtext('PI')
gtext('PID')
nicegrid;