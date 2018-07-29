%  Figure 3.27c      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
%

clf;
zeta=0.7;
k=1/zeta;
den=[1 2*zeta 1];
t=0:.1:10;

a=10;
num=[k/a 1];
y1=step(num,den,t);

a=4;
num=[k/a 1];
y2=step(num,den,t);

a=2;
num=[k/a 1];
y3=step(num,den,t);

a=1;
num=[k/a 1];
y4=step(num,den,t);

a=.5;
num=[k/a 1];
y5=step(num,den,t);

axis([0 6 1 1.8])
plot(t,y1,'-',t,y2,'-',t,y3,'-',t,y4,'-',t,y5,'-'),
title('Fig. 3.27 (c) Step response with \xi = 0.7')
xlabel('\omega_n t')
ylabel('Step response of H(s)')
% grid
nicegrid
