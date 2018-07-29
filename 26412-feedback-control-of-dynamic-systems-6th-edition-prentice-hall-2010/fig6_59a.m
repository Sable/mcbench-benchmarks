% Fig. 6.59a   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%
% response comparison of continuous and digital control step.

clear all;
%close all;
clf

sim('fig6_58step')
r=[1 1];   %reference input
t=[0 5];
plot(t,r,'r')
hold on
plot(ycd(:,1),ycd(:,2))
plot(ycd(:,1),ycd(:,3),'m:')
title('Figure 6.59(a) Step Responses of Digital and Continuous Controllers')
ylabel('y')
xlabel('Time (sec)')
text(1.1,1.06, '\leftarrow continuous  controller')
text(.7,1.23, '\leftarrow digital  controller')
nicegrid
hold off

