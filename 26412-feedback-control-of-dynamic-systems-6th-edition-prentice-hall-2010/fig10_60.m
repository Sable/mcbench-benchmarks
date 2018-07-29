%  Figure 10.60      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
%
% script for disk read/write head control design
% the design is based on 1/s^2 with robustness
% with respect to a resonance of damping zeta = z at wm.
% the design calls for a single lead selected to maximize wc
% the phase margin is set by alpha = a
% the compensator has a second order roll-off filter
% the resonance is 'gain stabilized' with GM 
% the time is scaled to milliseconds
wm= 5*pi
z=.05;
GM = 4;
a=0.1;
% input the nominal plant with a gain of 1.
numGo=1;
denGo= [1 0 0];
sysGo=tf(numGo,denGo);
% input the plant with the resonance
numG= [1/(50*pi) 1];
denG=[1/(25*pi^2) 1/(50*pi) 1  0 0];
sysG=tf(numG,denG);
% Define the design constant
A = ((a*2*z)/(GM))^.333;
% PM >50; we have selected alpha = a = 0.1
Tinv= A*wm*sqrt(a);
T=1/Tinv;
wc =  A*wm
% K =  wc^2;
K=  wc^2;
% Input the lead compensation
numD =K*sqrt(a)*[T 1];
denD = [a*T 1];
sysD=tf(numD,denD);
% Now design the roll-off filter
w1=wm*sqrt(A/sqrt(a));
% design the roll-off damping
z1=.3 ;
numF=1;
denF=[1/w1^2  2*z1/w1 1];
sysF=tf(numF,denF);
% now compute the entire compensation
sysDc=sysD*sysF;
sysOLo=sysD*sysGo;
sysOL=sysDc*sysG;
% bode(sysOLo);
% hold on
clf;
sysH=tf(1,1);
sysCL=feedback(sysOL,sysH);
t=0:0.1:6;
[y,t]=step(sysCL,t);
plot(t,y);
xlabel('Time (msec)');
ylabel('Amplitude');
grid on
title('Fig. 10.60 Step response of disk control;lead plus roll-off ')
%grid
nicegrid