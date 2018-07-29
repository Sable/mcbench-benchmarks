%  Figure 7.69      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
% fig7_69.m    
clf;
n1=[5 25];
d=[1 10 25];
step([8 25],d)
hold on
step(n1, d);
step(25,d);
grid;
title('Fig. 7.69: Step response of integral control with feedforward');
%xlabel('Time (sec)');
ylabel('Amplitude');
text(0.5,.8,'0');
text(.4,.9,'5');
text(.4,1.1,'N=8');
hold off

