% Fig. 6.40   Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
%

clear all;
close all;

num=conv([1 10],[1 10]);
den=[1 0 0 0];
figure(1)
rlocus(num,den);
grid;
title('Fig. 6.40 (a) Root Locus');

figure(2)
w=logspace(-1,4,200);
[re,im]=nyquist(7*num,den,w);
plot(re,im,re,-im);
axis([-2 2 -2 2]);
axis('square')
grid;
title('Fig. 6.40 (b) Nyquist plot, K = 7');
xlabel('Real')
ylabel('Imaginary')
%return
%w=logspace(-1,2,100);
%num=7*num;
%[m,p]=bode(num,den,w);
%loglog(w,m);
%grid;
%semilogx(w,p);
%grid;









