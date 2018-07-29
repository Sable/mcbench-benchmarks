% Fig. 6.15   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%

clear all;
%close all;
clf

w=logspace(-2,2,100);
k=10;
num=k;
den=conv([1 0],[1 2 1]);
[m10,p10]=bode(num,den,w);
k=2;
num=k;
den=conv([1 0],[1 2 1]);
[m2,p2]=bode(num,den,w);
k=0.1;
num=k;
den=conv([1 0],[1 2 1]);
[mp1,pp1]=bode(num,den,w);
figure(1)
loglog(w,m10,w,m2,w,mp1,w,ones(size(w)));
xlabel('\omega (rad/sec)');
ylabel('Magnitude');
title('Fig. 6.15 Frequency Response (a) magnitude');
text(1,20,'K=10');
text(0.2,3,'K=2');
text(0.9,0.01,'K=0.1');
bodegrid;
%pause;
figure(2)
semilogx(w,p10,w,p2,w,pp1,w,-180*ones(size(w)),'-');
xlabel('\omega (rad/sec)');
ylabel('Phase (deg)')
title('Fig. 6.15 (b) phase');
bodegrid;


