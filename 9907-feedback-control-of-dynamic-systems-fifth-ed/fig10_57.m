%  Figure 10.57      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
% fig10_57.m is a script for disk read/write head control design
% the design is based on 1/s^2 with robustness
% with respect to a resonance of damping zeta = z at wm.
% the design calls for a single lead selected to maximize wc
% the phase margin is set by alpha = a
% the resonance is 'gain stabilized' with GM 
% the time is scaled to milliseconds
clf;
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
figure(1)
clf
% bode(sysOLo);
% hold on
w=logspace(-1,2);
[mag,ph]=bode(sysOL,w);  
subplot(211);
% convert to db
magdb=20*log10(mag(:,:));
magdb1=[magdb; zeros(size(magdb))];
semilogx(w,magdb1);
grid;
title('Fig. 10.57 Disk drive control with gain-stabilized resonance');
xlabel('\omega (rad/sec)');
ylabel('Magnitude (db)');
subplot(212);
semilogx(w,[ph(:,:); -180*ones(size(ph(:,:)))]);
grid;
xlabel('\omega (rad/sec)');
ylabel('Phase (deg)');
pause;
%hold off
[Gm,Pm,Wcg,Wcp] = margin(mag,ph,w) 