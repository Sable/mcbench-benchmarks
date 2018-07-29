%  Figure 3.12     Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
%  fig3_12.m 
clf;
num=[2 1];
den=[1 3 2];
axis ('square')
pzmap(num,den)
grid;
