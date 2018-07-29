% Fig. 6.54   Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
%

clear all;
close all;

k=10;
num=k;
den=[1 1 0];
w=logspace(-1,2,100);
[m,p]=bode(num,den,w);
num=conv(num,[.5 1]);
den=conv(den,[.1 1]);
[mc,pc]=bode(num,den,w);
figure(1)
loglog(w,m,w,mc);
grid;
xlabel('\omega (rad/sec)');
ylabel('Magnitude');
title('Fig. 6.54 (a) magnitude');
pause;
figure(2)
semilogx(w,p,w,pc);
grid;
xlabel('\omega (rad/sec)');
ylabel('Phase');
title('Fig. 6.54 (b) phase');
