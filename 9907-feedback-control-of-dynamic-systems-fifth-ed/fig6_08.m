% Fig. 6.8   Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
%

clear all;
close all;

num=1;
den=[10 1];
w=logspace(-3,2);
[m,p]=bode(num,den,w);;
p1=-p;
% asymptote
wa=[.02 .5];
pa=[0 90];
semilogx(w,p1,'-',wa,pa,'--');
grid;
xlabel('\omega (rad/sec)');
ylabel('Phase');
title('Fig. 6.8 Phase plot for j\omega \tau + 1; \tau = 10');
