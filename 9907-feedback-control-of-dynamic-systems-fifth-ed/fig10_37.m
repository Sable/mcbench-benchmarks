%  Figure 10.37      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
%% Fig. 10.37  Script for computation of the yaw damper
%  impulse response with feedback through a washout circuit.

clear all;
close all;
% the equations of the aircraft:

f =[-0.0558   -0.9968    0.0802    0.0415;
    0.5980   -0.1150   -0.0318         0 ;
   -3.0500    0.3880   -0.4650         0 ;
         0    0.0805    1.0000         0] ;
g =[0.0073;
   -0.4750;
    0.1530;
         0];
h = [0     1     0     0];
j =[0];
% the equations of the actuator:

na=[0 10];
da=[1 10];
[fa,ga,ha,ja]=tf2ss(na,da);

% the equations of the aircraft with actuator:

[fp,gp,hp,jp]=series(fa,ga,ha,ja,f,g,h,j);
% the washout circuit
nw=[1 0];dw=[1 1/3];
[fw,gw,hw,jw]=tf2ss(nw,dw);
%  Open-loop equations with washout
[fpw,gpw,hpw,jpw]=series(fp,gp,hp,jp,fw,gw,hw,jw);
 % the washout compensated root locus
 hold off; clf
%  axis([-2 2 -1.5 1.5]); 
rlocus(fpw,-gpw,hpw,jpw)
pause;
figure(2)
% the closed-loop system with washout feedback
[ac,bc,cc,dc]= feedback(fp,gp,hp,jp,fw,gw,-2.62*hw,-2.62*jw);
% impulse response of the yaw-rate system
bc1=[1 0 0 0 0 0]';   % input to put initial condition on beta
t=0:.2:30;
[yol]=impulse(f,[1 0 0 0]',[1 0 0 0],j,1,t); hold on
plot(t,yol,'-');
text(8,0.7,'No feedback')
title('Fig 10.37: Initial condition response')
[ywo]=impulse(ac,bc1, [ 1     0     0     0     0     0],dc,1,t); 
plot(t,ywo,'--');
text(18,0.7,'Yaw rate feedback');
grid;
hold on


% desired closed-loop poles   
p=[-.0051 -.468 -1.106 -9.89 -.279+i*.628 -.279-i*.628]'; 
k=place(fpw,gpw,p);
pe=5*p;  % estimator poles
L=place(fpw',hpw',pe)';
ae=fpw-gpw*k-L*hpw;
be=L;
ce =k;
de=0;

[Ac, Bc, Cc, Dc]=feedback(fpw,gpw,hpw,jpw,ae,be,ce,de);
Bc1=[0 1 0 0 0 0 0 0 0 0 0 0]';
Cc1=[0 1 0 0 0 0 0 0 0 0 0 0];  % note beta output!

% impulse response of the yaw-rate system with LQR feedback

[ylqr]=impulse(Ac,Bc1,Cc1,Dc,1,t); 
plot(t,ylqr,'-.')
text(6.5,-0.2,'SRL')
xlabel('Time (sec)');
ylabel('\beta (deg)');
hold off







