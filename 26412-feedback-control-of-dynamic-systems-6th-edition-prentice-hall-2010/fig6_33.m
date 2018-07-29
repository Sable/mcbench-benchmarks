% Fig. 6.33   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%

clear all;
%close all;
clf

num=[1 0 3];
den=conv([1 1],[1 1]);
w=logspace(-3,3,100);
[re,im]=nyquist(num,den,w);
plot(re,im,re,-im);
axis([-2 4 -3 3]);
axis('square')
xlabel('Re(G(s))');
ylabel('Im(G(s))');
title('Fig. 6.33 Nyquist plot for Example 6.11');
nicegrid;
