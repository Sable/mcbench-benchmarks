% Fig. 8.10   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%

clear all;
%close all;
clf

numG=1;
denG=[1 0 0];

numD=[1 .2];
denD=[1 2];

num=conv(numG,numD);
den=conv(denG,denD);
poles=roots(den);
zeros=roots(num);


K1=0:.05:1.22;
K2=[1.25 1.28];  % K for break-in and break-away points
K3=1.5:5:100;
K=[K1 K2 K3];
Ko=.81;

r=rlocus(num,den,K);
ro=rlocus(num,den,Ko);

plot(r,'-'),
axis('square')
axis([-2.5 .5 -1.5 1.5])
hold on
plot(ro,'k*')
plot(-.2,0,'o')
plot(-2,0,'x')
plot(0,.01,'x')
plot(0,-.01,'x')
title('Fig. 8.10  s-plane locus vs. K')
xlabel('Re(s)')
ylabel('Im(s)')
text(-2.3,-.7,'*  K_c = 0.81') 
nicegrid
hold off

