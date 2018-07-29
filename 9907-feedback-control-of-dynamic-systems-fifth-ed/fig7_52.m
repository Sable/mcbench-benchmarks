%  Figure 7.52      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
% script for fig. 7.52
%  
clf;
dp=[1 1 0];
np=[1];
nc=conv([1 1.001],[8.32 0.8]);
dc=conv([1 4.08],[1 0.0196]);
num=conv(np,nc);
den=conv(dp,dc);
w=logspace(-2,2);
sys=tf(num,den);
[mag, ph]=bode(sys,w);
mag1=[mag(:,:); ones(size(mag(:,:)))];
ph1=[ph(:,:);-180*ones(size(ph(:,:)))];
subplot(211) , loglog(w,mag1), grid;
xlabel('\omega (rad/sec)');
ylabel('Magnitude');
title('Fig.7.52 Bode plot for lag compensation design')
subplot(212), semilogx(w,ph(:,:)), grid
xlabel('\omega (rad/sec)');;
ylabel('Phase (deg)');