%  Figure 7.40      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
%
% script to generate Fig. 7.40  
clf;
clear all;
np=1;
dp=[1, 0, 0];
nc=8.07*[1, 0.619];
dc=[1, 6.41];
num=conv(np,nc);
den=conv(dp,dc);
w=logspace(-1,2);
sys=tf(num,den);
[mag, ph]=bode(sys,w);
mag1=[mag(:,:); ones(size(mag(:,:)))];
ph1=[ph(:,:); -180*ones(size(ph(:,:)))];
subplot(211), 
loglog(w,mag1), 
grid on;
xlabel('\omega (rad/sec)');
ylabel('Magnitude');
title('Fig.7.40 Bode plot for reduced-order controller for 1/s^2')
subplot(212);
semilogx(w,ph1);
xlabel('\omega (rad/sec)');
ylabel('Phase (deg)');
%Bode grid
bodegrid