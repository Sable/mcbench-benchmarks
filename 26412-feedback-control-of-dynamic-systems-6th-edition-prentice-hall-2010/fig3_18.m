%  Figure 3.18     Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
% script to generate Fig. 3.18
%  fig3_18.m                                                     
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

zeta=.4;
den=[1 2*zeta 1];
y5=impulse(num,den,t);

zeta=.5;
den=[1 2*zeta 1];
y6=impulse(num,den,t);

zeta=.6;
den=[1 2*zeta 1];
y7=impulse(num,den,t);

zeta=.7;
den=[1 2*zeta 1];
y8=impulse(num,den,t);
figure();
plot(t,y1,'-',t,y2,'-',t,y3,'-',t,y4,'-')

zeta=.8;
den=[1 2*zeta 1];
y9=impulse(num,den,t);

zeta=.9;
den=[1 2*zeta 1];
y10=impulse(num,den,t);

zeta=1;
den=[1 2*zeta 1];
y11=impulse(num,den,t);
plot(t,y1,t,y2,t,y3,t,y4,t,y5,t,y6,t,y7,t,y8,t,y9,t,y10,t,y11)
axis([0 12 -1 1])
title('Fig. 3.18 (a) Impulse response vs. \xi')
xlabel('\omega_n t ')
ylabel('y(t)')

% grid
nicegrid

hold off
pause;
%  Figure 3.18 (b)     
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


zeta=.4;
den=[1 2*zeta 1];
y5=step(num,den,t);

zeta=.5;
den=[1 2*zeta 1];
y6=step(num,den,t);

zeta=.6;
den=[1 2*zeta 1];
y7=step(num,den,t);

zeta=.7;
den=[1 2*zeta 1];
y8=step(num,den,t);

zeta=.8;
den=[1 2*zeta 1];
y9=step(num,den,t);

zeta=.9;
den=[1 2*zeta 1];
y10=step(num,den,t);

zeta=1;
den=[1 2*zeta 1];
y11=step(num,den,t);
axis([0 12 0 2])
figure();
plot(t,y1,t,y2,t,y3,t,y4,t,y5,t,y6,t,y7,t,y8,t,y9,t,y10,t,y11),
title('Fig. 3.18 (b) Step response vs. \xi')
xlabel('\omega_n t ')
ylabel('y(t)')

% grid
nicegrid

hold off

