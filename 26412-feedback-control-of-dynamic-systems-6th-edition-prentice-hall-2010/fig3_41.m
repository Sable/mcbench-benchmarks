%  Figure 3.41      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
% script to generate Fig. 3.41
clf;
t=0:.05:10;
k=1;
ki=0;
numCL=[k ki];
denCL=[1 3 2+k ki];
y1=step(numCL,denCL,t);
ki=1;
numCL=[k ki];
denCL=[1 3 2+k ki];
y2=step(numCL,denCL,t);
k=10;
ki=5;
numCL=[k ki];
denCL=[1 3 2+k ki];
y3=step(numCL,denCL,t);
axis([0 10 0 1.2]);
plot(t,y1,t,y2,t,y3);
xlabel('Time (sec)');
ylabel('y(t)');
title('Fig. 3.41 Transient responses');
axis('normal');
text(2,.25,'K = 1, K_I = 0');
text(3,0.75,'K= 1, K_I = 1');
text(1.5,1.1,'K = 10, K_I = 5');
%grid
nicegrid


