%  Figure 10.58      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
% fig10_58.m is a script for disk read/write head control design 
% the design is based on 1/s^2 with robustness
% with respect to a resonance of damping zeta = z at wm.
% the design calls for a single lead selected to maximize wc
% the phase margin is set by alpha = a
% the resonance is 'gain stabilized' with GM 
% the time is scaled to milliseconds

wm= 5*pi
z=.05;
GM = 4;
a=0.1;
numGo=1;
denGo= [1 0 0];
sysGo=tf(numGo,denGo);
numG= [1/(50*pi) 1];
denG=[1/(25*pi^2) 1/(50*pi) 1  0 0];
sysG=tf(numG,denG);
b=GM/(2*z);
% PM >50; select alpha = 0.1
T= (1/wm)*sqrt(b/a^1.5);
wc = 1/(sqrt(a)*T)
% K = sqrt(a)*wc^2
K= sqrt(a)*wm^2/b;
numD =K*sqrt(a)*[T 1];
denD = [a*T 1];
sysD=tf(numD,denD);
sysOLo=sysD*sysGo;
sysOL=sysD*sysG;
%figure(1)
%clf
% bode(sysOLo);
%hold on
%bode(sysOL);  
%title('Disk drive control with gain-stabilized resonance');
%pause;
%hold off
%figure(2)
clf
sysH=tf(1,1);
sysCL=feedback(sysOL,sysH);
[y,t]=step(sysCL);
plot(t,y);
grid;
xlabel('Time (msec)');
ylabel('Amplitude');
title('Fig. 10.58 Step response of disk control with PM = 50 deg')
