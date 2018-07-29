% Fig. 8.8   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami

%    (requires fig8_08c.mdl)

clear all;
%close all;

% response comparison of continuous and digital control.

clear
clf
[tout,yout]=sim('fig8_08c');
r=[1 1];   %reference input
t=[0 2];
figure(1)
subplot(2,1,1)
plot(t,r,'r')
hold on
plot(ycd(:,1),ycd(:,2))
plot(ycd(:,1),ycd(:,3),'m')
title('Figure 8.8 Step Responses of Digital and Continuous Controllers')
ylabel('Position, y')
xlabel('Time (sec)')
text(.33,.9, '\leftarrow continuous  controller')
text(.7,1.3, 'digital  controller')
nicegrid
hold off
subplot(2,1,2)
plot(ycd(:,1),ycd(:,4))
hold on
plot(ycd(:,1),ycd(:,5),'m')
ylabel('Control, u')
xlabel('Time (sec)')
text(.55,10, ' continuous  controller')
text(.08,29, '\leftarrow digital  controller')
nicegrid
hold off
