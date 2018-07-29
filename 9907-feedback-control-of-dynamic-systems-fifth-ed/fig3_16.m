%  Figure 3.16     Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%script to generate Fig. 3.16
%  fig3_16.m                                                     
%
clf;
num=1;
t=0:.0001:12;

zeta=0;
den=[1 2*zeta 1];
y1=impulse(num,den,t);

zeta=.1;
den=[1 2*zeta 1];
y2=impulse(num,den,t);

zeta=.2;
den=[1 2*zeta 1];
y3=impulse(num,den,t);

zeta=.3;
den=[1 2*zeta 1];
y4=impulse(num,den,t);

axis([0 12 -1 1])
plot(t,y1,'-',t,y2,'-',t,y3,'-',t,y4,'-'),grid
title('Fig. 3.16 (a) Impulse response vs. \xi')
xlabel('\omega_n t ')
ylabel('y(t)')
hold on

zeta=.4;
den=[1 2*zeta 1];
y1=impulse(num,den,t);

zeta=.5;
den=[1 2*zeta 1];
y2=impulse(num,den,t);

zeta=.6;
den=[1 2*zeta 1];
y3=impulse(num,den,t);

zeta=.7;
den=[1 2*zeta 1];
y4=impulse(num,den,t);

plot(t,y1,'-',t,y2,'-',t,y3,'-',t,y4,'-')

zeta=.8;
den=[1 2*zeta 1];
y1=impulse(num,den,t);

zeta=.9;
den=[1 2*zeta 1];
y2=impulse(num,den,t);

zeta=1;
den=[1 2*zeta 1];
y3=impulse(num,den,t);

plot(t,y1,'-',t,y2,'-',t,y3,'-')
hold off
pause;
%  Figure 3.16b     
clf
num=1;
t=0:.0001:12;

zeta=0;
den=[1 2*zeta 1];
y1=step(num,den,t);

zeta=.1;
den=[1 2*zeta 1];
y2=step(num,den,t);

zeta=.2;
den=[1 2*zeta 1];
y3=step(num,den,t);

zeta=.3;
den=[1 2*zeta 1];
y4=step(num,den,t);

axis([0 12 0 2])
plot(t,y1,'-',t,y2,'-',t,y3,'-',t,y4,'-'),grid
title('Fig. 3.16 (b) Step response vs. \xi')
xlabel('\omega_n t ')
ylabel('y(t)')
hold on

zeta=.4;
den=[1 2*zeta 1];
y1=step(num,den,t);

zeta=.5;
den=[1 2*zeta 1];
y2=step(num,den,t);

zeta=.6;
den=[1 2*zeta 1];
y3=step(num,den,t);

zeta=.7;
den=[1 2*zeta 1];
y4=step(num,den,t);

plot(t,y1,'-',t,y2,'-',t,y3,'-',t,y4,'-')

zeta=.8;
den=[1 2*zeta 1];
y1=step(num,den,t);

zeta=.9;
den=[1 2*zeta 1];
y2=step(num,den,t);

zeta=1;
den=[1 2*zeta 1];
y3=step(num,den,t);

plot(t,y1,'-',t,y2,'-',t,y3,'-')
hold off
