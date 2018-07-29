%  Figure 6.71      Feedback Control of Dynamic Systems, 6e
%                   Franklin, Powell, Emami
% 

clear all
%close all;
clf

num=0.9*2;
den=[1 2 0 0];
w=logspace(-4,3,100);
Nw=size(w);
[m,p]=bode(num,den,w);
n1=conv([10 1],[1 0.005]);
num=conv(num,n1);
den=conv(den,[1 0]);
[mc,pc]=bode(num,den,w);
subplot(2,1,1)
loglog(w,m,w,mc,'--',w,ones(Nw));
axis([.0001 100 .01 1000])
%xlabel('\omega (rad/sec)');
ylabel('Magnitude');
title('Fig. 6.71: Compensation for PID design example: (a) magnitude.');
nicegrid;
subplot(2,1,2)
if p>0, p=p-360; end      % Matlab quadrant control varies in different versions
if pc>0, pc=pc-360; end
semilogx(w,p,w,pc,'--',w,-179*ones(Nw));
axis([.0001 100 -270 -90])
xlabel('\omega (rad/sec)');
ylabel('Phase (deg)');
title('Fig. 6.71: Compensation design for PID example: (b)phase.');
nicegrid;
