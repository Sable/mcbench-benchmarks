%  Figure 3.38      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
%
% script to generate Fig. 3.38
clf;
k=7.5;
numCL=[k k];
denCL=[1 5 k-6 k];
t=0:.05:12;
y1=step(numCL,denCL,t);
k=13;
numCL=[k k];
denCL=[1 5 k-6 k];
y2=step(numCL,denCL,t);
k=25;
numCL=[k k];
denCL=[1 5 k-6 k];
y3=step(numCL,denCL,t);
axis([0 12 -1 3]);
plot(t,y1,t,y2,t,y3)
xlabel('Time (sec)');
ylabel('y(t)');
title('Fig. 3.38 transient responses')
axis('normal');
text(3,2,'K=7.5');
text(2.1,1.5,'K=13');
text(1.4,1.2,'K=25');
% grid
nicegrid;
