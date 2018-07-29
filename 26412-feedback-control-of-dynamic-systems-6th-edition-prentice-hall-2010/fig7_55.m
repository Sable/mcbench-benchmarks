%  Figure 7.55      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
%
% script for Fig. 7.55             
% 
clf;
dp=[1 1 0];
np=[1];
nc=conv([1 1],[8.32 0.8]);
dc=conv([1 4.08],[1 0.0196]);
num=conv(np,nc);
den=conv(dp,dc);
dcl=[0 0 num]+den; % closed-loop denominator
t=0:.1:5;
sys=tf(num,dcl);
y=step(sys,t);
plot(t,y)
grid;
xlabel('Time (sec)');
ylabel('y');
title('Fig.7.55 Step response for lag compensation design');
[a,b,c,d]=tf2ss(nc,dc);
% Samplig period
ts=0.1;
% Convert controller to discrete
[ad,bd,cd,dd]=c2dm(a,b,c,d,ts,'zoh');
[ncd,dcd]=ss2tf(ad,bd,cd,dd);
% response comparison of continuous and digital control.
sim('fig7_54')
figure(1)
plot(ycd(:,1),ycd(:,2))
hold on
plot(ycd(:,1),ycd(:,3),'g--')
title('Figure 7.53(a) Output Responses of Digital and Continuous Controllers')
xlabel('Time (sec)');
ylabel('y');
text(0.5,0.5,'continuous controller')
text(0.1,1.15,'digital controller')
nicegrid
hold off
%pause;
figure(2)
plot(ucd(:,1),ucd(:,2))
hold on
plot(ucd(:,1),ucd(:,3),'g--')
title('Figure 7.55(b)  Control Responses of Digital and Continuous Controllers')
xlabel('Time (sec)');
ylabel('u');
text(0.5,0.5,'continuous controller')
text(1.1,-1.5,'digital controller')
nicegrid
hold off

