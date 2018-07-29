% Fig. 8.16   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%

clear all;
%close all;
clf

alpha = .7;
numGz=1 - alpha;
denGz=[1 -alpha];  

K = [0 100];
r=rlocus(numGz,denGz,K);
subplot(1,2,1)
plot(real(r),[0;0],'-'),
axis('square')
axis([-1.5 1.5 -1.5 1.5])
hold on
plot(alpha,0,'x')
title('Fig. 8.15a  z-plane locus')
xlabel('Re(s)')
ylabel('Im(s)')
nicegrid

% unstable point

Ku = (1 + alpha)/(1 - alpha);
ru=rlocus(numGz,denGz,Ku);
plot(ru,0,'*')

% now put in unit circle

th=0:.1:2.1*pi;
xc=cos(th);
yc=sin(th);
plot(real(r),[0;0],'-',xc,yc,'r')
plot(alpha,0,'x')
%title('Fig. 8.16 (a)  z-plane locus')
xlabel('Re(s)')
ylabel('Im(s)')
hold off

% now do s-plane locus
% assume T = 1 sec

T=1;
so = -log(alpha)/T;
numGs=so;
denGs=[1 so];
subplot(1,2,2)
K = [0 100];
rs=rlocus(numGs,denGs,K);
ru=rlocus(numGs,denGs,Ku);

plot(real(rs),[0;0],'-',ru,0,'*'),
axis([-5 1 -3 3])
axis('square')
hold on
plot(-so,0,'x')
title('Fig. 8.16 (b)  s-plane locus')
xlabel('Re(s)')
ylabel('Im(s)')
nicegrid
% stability boundary
xIm=[0 0];
yIm=[-3 3];
plot(xIm, yIm,'r')
hold off


