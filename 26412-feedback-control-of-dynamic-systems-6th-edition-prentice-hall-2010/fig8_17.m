% Fig. 8.17   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%

clear all;
%close all;
clf

% z-plane locus

numGz=[1 1];
denGz=[1 -2 1];  

K1 = 0:.2:8;  % break-in point is at K = 8
K2 = 100;
K = [K1 K2];
r=rlocus(numGz,denGz,K);
plot(r,'-'),
axis('square')
axis([-4 2 -3 3])
hold on
plot(1,.01,'x')
plot(1,-.01,'x')
plot(-1,0,'o')
title('Fig. 8.17  z-plane locus for 1/s^2 plant')
xlabel('Re(s)')
ylabel('Im(s)')
nicegrid

% now put in unit circle

th=0:.1:2.1*pi;
xc=cos(th);
yc=sin(th);
plot(xc,yc,'r--')
hold off
