% Fig. 6.30   Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
%

clear all;
close all;

num=[1 1];
den=conv([1 0],[0.1 -1]);
w=logspace(-1,2,100);
[m,p]=bode(num,den,w);
subplot(2,1,1),loglog(w,m,'-',w,ones(size(w)),'-');
grid;
ylabel('Magnitude');
title('Fig. 6.30 Bode Plot for G=(s+1)/[s(s/10 -1)] (a) magnitude');
subplot(2,1,2)
if p>0, p=p-360; end      % Matlab quadrant control varies in different versions
semilogx(w,p,'-',w,-180*ones(size(w)),'-');
axis([.1 100 -270 -90])
grid;
xlabel('\omega (rad/sec)');
ylabel('Phase (deg)');
title('(b) phase');
