% Fig. 6.31   Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
%

clear all;
close all;

num=[1 1];
den=conv([1 0],[0.1 -1]);
w=logspace(-3,3,100);
[re,im]=nyquist(num,den,w);
plot(re,im,re,-im);
axis([-2 2 -2 2]);
axis('square')
xlabel('Re(G(s))');
ylabel('Im(G(s))');
title('Fig. 6.31 Nyquist plot for Example 6.10');
grid
