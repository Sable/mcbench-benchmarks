% Fig. 6.23   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%

clear all;
%close all;
clf

num=1;
den=[1 2 1];
w=logspace(-2,3,100);
[re,im]=nyquist(num,den,w);

plot(re,im,re,-im);
axis equal
xlabel('Re(G(s))');
ylabel('Im(G(s))');
title('Fig. 6.23 Nyquist plot');
nicegrid;

