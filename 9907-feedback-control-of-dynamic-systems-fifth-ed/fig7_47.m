%  Figure 7.47      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
% script for fig. 7.47               
%  
% 
clf;
dp=[1 10 16 0];
np=[10];
nc=94.5*conv([1 7.98],[1 2.52]);
dc=conv([1 8.56 59.5348],[1 10.6]);
num=conv(np,nc);
den=conv(dp,dc);
dcl=[0 0 0 0 num]+den; % closed-loop denominator
t=0:.1:5;
sys=tf(num,dcl);
y=step(sys,t);
plot(t,y)
grid;
xlabel('Time (sec)');
ylabel('y');
title('Fig.7.42 Step response for SRL compensation design: continuous');
pause;
[a,b,c,d]=tf2ss(nc,dc);
% Samplig period
ts=0.1;
% Convert controller to discrete
[ad,bd,cd,dd]=c2dm(a,b,c,d,ts,'zoh');
[ncd,dcd]=ss2tf(ad,bd,cd,dd)

% response comparison of continuous and digital control.
sim('fig7_46')
figure(1)
plot(ycd(:,1),ycd(:,2))
hold on
plot(ycd(:,1),ycd(:,3),'--')
title('Figure 7.47(a) Output Responses of Digital and Continuous Controllers')
xlabel('Time (sec)');
ylabel('y');
grid on;
gtext('continuous controller');
gtext('digital controller');
hold off
pause;
figure(2)
plot(ucd(:,1),ucd(:,2))
hold on
plot(ucd(:,1),ucd(:,3),'--')
title('Figure 7.47(b)  Control Responses of Digital and Continuous Controllers')
xlabel('Time (sec)');
ylabel('u');
grid on;
gtext('continuous controller')
gtext('digital controller')
hold off

