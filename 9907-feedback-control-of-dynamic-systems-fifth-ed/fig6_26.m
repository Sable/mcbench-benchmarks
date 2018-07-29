% Fig. 6.26   Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
%

clear all;
close all;

num=1;
den=conv([1 0],[1 2 1]);
w=logspace(-2,3,100);
[re,im]=nyquist(num,den,w);
plot(re,im,re,-im);
axis([-2 2 -2 2]);
axis('square')
xlabel('Re(G(s))');
ylabel('Im(G(s))');
title('Fig. 6.26 Nyquist plot');
grid;
hold on
ii=[11 21 47 61];
plot(re(ii),im(ii),'*');
plot(-.5,0,'*')
hold off
