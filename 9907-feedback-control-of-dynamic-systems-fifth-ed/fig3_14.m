%  Figure 3.14      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%script to generate Fig. 3.14
%  fig3_14.m      
%  Example 3.22    
clf;
num=[2 1];
den=[1 3 2];
t=0:0.1:6;
y=impulse(num,den,t);
plot(t,y,'-')
grid
title('Fig. 3.14  Example 3.22 system impulse response.')
xlabel('Time (sec)')
ylabel('h(t)')
