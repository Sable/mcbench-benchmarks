%  Figure 3.24      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%script to generate Fig. 3.24


clf;
zeta=.5;
k=1/zeta;
den=[1 1 1];

a=10;
num=[k/a 1];
t=0:.1:10;
y1=step(num,den,t);

a=4;
num=[k/a 1];
t=0:.1:10;
y2=step(num,den,t);

a=2;
num=[k/a 1];
t=0:.1:10;
y3=step(num,den,t);

a=1;
num=[k/a 1];
t=0:.1:10;
y4=step(num,den,t);

plot(t,y1,'-',t,y2,'-',t,y3,'-',t,y4,'-'),grid
title('Fig. 3.24 Step response with \xi = 0.5')
xlabel('\omega_n t')
ylabel('Step response of H(s)')
text(.1,.9,'\alpha=')
text(.6,.9,'1')
text(1.1,.9,'2')
text(1.5,.85,'4')
text(1.8,.8,'100')