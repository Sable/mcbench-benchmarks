% Fig. 8.18   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%

clear all;
%close all;
clf

numGs=1;
denGs=[1 0 0];  % s^2

% discrete design

T=1;
[numGz,denGz]=c2dm(numGs,denGs,T,'zoh');

numDz2=.374*[1 -.85];
denDz2=[1 0];

numz2=conv(numGz,numDz2);
denz2=conv(denGz,denDz2);
sysD=tf(numz2,denz2,T);
rlocus(sysD)
zgrid
axis([-1.2 1.2 -1.2 1.2])
axis equal
title('Fig. 8.18 Compensated z-plane locus for 1/s^2 plant')
hold on
r=rlocus(sysD,1);
plot(real(r(1)),imag(r(1)),'k*',real(r(2)),imag(r(2)),'k*',real(r(3)),0,'k*')
text(.2,-1.3,'*  desired root locations')
ddamp(r',T)
hold off


