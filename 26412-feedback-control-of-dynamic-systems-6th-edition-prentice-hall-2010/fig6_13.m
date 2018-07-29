% Fig. 6.13   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%

clear all;
%close all;
clf

num=10;
den=[1 1 0];
w=logspace(-2,1,100);
[m,p]=bode(num,den,w);
wa=[.01 1.2];
ma=[1000 8.3333];
loglog(w,m,w,10*ones(1,100),'--',wa,ma);
xlabel('\omega (rad/sec)');
ylabel('Magnitude');
title('Fig. 6.13 Determination of Kv from the Bode plot');
bodegrid;
