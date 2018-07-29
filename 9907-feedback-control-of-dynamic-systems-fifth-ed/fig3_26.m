%  Figure 3.26      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%script to generate Fig. 3.26
clf;
a=1;
zeta=.5;
k=1/zeta;
den=[1 1 1];
num=[k/a 1];
t=0:.1:10;
yT=step(num,den,t);

num=[0 1];
yo=step(num,den,t);

num=[k/a 0];
yd=step(num,den,t);

axis([0 10 -.2 1.8])
plot(t,yo,'-',t,yd,'-',t,yT,'--'),grid
text(3,.4,'H_d(s)');
text(2.2,.85,'H_0(s)');
text(3,1.5,'H(s)');
title('Fig. 3.26 Step response and its derivative')
xlabel('Time (sec)')
ylabel('y(t)')
