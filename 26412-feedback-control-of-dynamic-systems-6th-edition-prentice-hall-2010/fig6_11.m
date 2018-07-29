% Fig. 6.11   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%

clear all;
%close all;
clf

num=0.01*[1 0.01 1];
den=conv([1 0 0],[.25 0.01 1]);
w=logspace(-2,2,1000);
[m,p]=bode(num,den,w);

subplot(2,1,1)
loglog(w,m);
axis([.01 10 .0001 100])
%xlabel('\omega (rad/sec)');
ylabel('Magnitude');
title('Fig. 6.11 Bode plot for a TF w/ complex p & z. (a) magnitude');
bodegrid;

subplot(2,1,2)
semilogx(w,p);
axis([.01 10 -200 0])
xlabel('\omega (rad/sec)');
ylabel('Phase');
title('Fig. 6.11 (b) phase');
bodegrid;



