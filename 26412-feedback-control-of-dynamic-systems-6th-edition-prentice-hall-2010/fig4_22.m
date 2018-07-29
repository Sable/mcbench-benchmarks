%Figure 4.22a and 4.22b   Feedback Control of Dynamic Systems, 6e
%                      Franklin, Powell, Emami
% 
% response comparison of continuous and digital control.
clf;
numC=[1 6];
denC=[1 0];
sysc=tf(numC,denC)
T=.07; 
sysD=c2d( sysc,T,'t');
[numD,denD]=tfdata(sysD,'v' )
sim('fig4_21sim')
figure(1)
plot(ycd(:,1),ycd(:,2),':')
hold on
plot(ycd(:,1),ycd(:,3))
xlabel('Time (sec)');
ylabel('Output responses');
title('Figure 4.22(a) Output Responses')
gtext('continuous controller')
gtext('discrete controller, T =.07')
nicegrid;
pause;
figure(2)
plot(ucd(:,1),ucd(:,2),':')
hold on
plot(ucd(:,1),ucd(:,3))
title('Figure 4.22(b)  Control Responses')
xlabel('Time (sec)');
ylabel('Control signals');
gtext('continuous controller')
gtext('discrete controller, T=.07')
nicegrid;
pause
%hold off;
% close all;
T=.035;

sysD=c2d( sysc,T,'t');
[numD,denD]= tfdata(sysD,'v')
sim('fig4_21sim')
figure(1)
plot(ycd(:,1),ycd(:,2),':')
hold on
plot(ycd(:,1),ycd(:,3))
xlabel('Time (sec)');
ylabel('Output responses');
gtext('discrete controller, T =.035')
% hold off
pause;
figure(2)
plot(ucd(:,1),ucd(:,2),':')
hold on
plot(ucd(:,1),ucd(:,3))
xlabel('Time (sec)');
ylabel('Control signals');
gtext('discrete controller, T=.035')
nicegrid;
hold off
