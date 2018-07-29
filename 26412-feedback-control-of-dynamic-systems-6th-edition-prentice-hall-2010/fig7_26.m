%  Figure 7.26      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
%
% fig7_26.m
% Script to plot the step position responses of the tape
% drive servo for LQR designs             
% 
clf;

f =[0    2.0000         0         0         0;
   -0.1000   -0.3500    0.1000    0.1000    0.7500;
         0         0         0    2.0000         0 ;
    0.4000    0.4000   -0.4000   -1.4000         0  ;
         0   -0.0300         0         0   -1.0000   ];

g =[0;
     0;
     0 ;
     0  ;
     1   ];
h3 =[0.5000         0    0.5000         0         0];
ht =[-0.2000   -0.2000    0.2000    0.2000         0];

j=[0];

s=[f g;h3 j];
r=[0 0 0 0 0 1]';
n=s\r
nu=n(6);
nx=n(1:5)

t=0:.2:12;
rho=1;
klqr=lqr(f,g,rho*h3'*h3,1)

%klqr =[0.6526    2.1667    0.3474    0.5976    1.0616];

flqrc=f-g*klqr;
nbarlqr = klqr*nx+nu;

sys=ss(flqrc,g*nbarlqr,h3,j);

[ylqr]=step(sys,t);
figure(1)
plot(t,[ylqr],'LineWidth',2);
title('Fig. 7.26 (a): Step responses of tape servo designs')
xlabel('Time (msec)');
ylabel('Tape position, x_3');
grid
hold on;

rho=10;
klqr2=lqr(f,g,rho*h3'*h3,1)

flqrc2=f-g*klqr2;
nbarlqr2 = klqr2*nx+nu;

sys2=ss(flqrc2,g*nbarlqr2,h3,j);

[ylqr2]=step(sys2,t);

plot(t,[ylqr ylqr2])

hold on;

rho=0.1;
klqr3=lqr(f,g,rho*h3'*h3,1)

flqrc3=f-g*klqr3;
nbarlqr3 = klqr3*nx+nu;

sys3=ss(flqrc3,g*nbarlqr3,h3,j);

[ylqr3]=step(sys3,t);

plot(t,ylqr,t,ylqr2,t,ylqr3,'--','LineWidth',2);
text(2.1,.7,'\rho=10');
text(3.3,.7,'\rho=1');
text(5,.7,'\rho=0.1');
nicegrid
hold off;

pause;

%Tension Responses

syst=ss(flqrc,g*nbarlqr,ht,j);

Tlqr=step(syst,t);

syst2=ss(flqrc2,g*nbarlqr,ht,j);

Tlqr2=step(syst2,t);

syst3=ss(flqrc3,g*nbarlqr,ht,j);

Tlqr3=step(syst3,t);

figure(2)
plot(t,Tlqr,t,Tlqr2,t,Tlqr3,'--','LineWidth',2);
title('Fig. 26 (b)Tension plots for tape servo step responses')
xlabel('Time (msec)');
ylabel('Tape tension, T');
text(3,-0.025,'\rho = 10');
text(4,-0.05,'\rho = 1');
text(6,-.1,'\rho = 0.1');
nicegrid;


