% Fig. 6.57b   Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
%

clear all;
close all;
% response comparison of continuous and digital control ramps.

clear
clf
sim('fig6_57d')
r=[0 2];   %reference input
t=[0 2];
%subplot(2,1,1)
plot(t,r,'r--')
hold on
plot(ycd(:,1),ycd(:,2))
plot(ycd(:,1),ycd(:,3),'m:')
title('Figure 6.57(b) Ramp Responses of Digital and Continuous Controllers')
ylabel('y')
xlabel('Time (sec)')
text(.84,.7, '\leftarrow continuous  controller')
text(.33,.1, '\leftarrow digital  controller')
text(.87,.9,'input ramp, r \rightarrow','HorizontalAlignment','right')
grid
hold off

