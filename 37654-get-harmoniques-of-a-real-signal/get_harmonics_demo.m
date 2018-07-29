%demo
clc;
clear
a0=10;a1=5;a2=-4;a3=0;a4=-2;a5=0;
b1=-3;b2=15;b3=0;b4=0;b5=0;
w0=2; % a pulse (rd/s) of a signal y
pas=pi/10
t=0:pas:pi-pas; % in this examle a period is T=2pi/w0=2pi/2=pi
y=a0+a1*cos(w0*t)+b1*sin(w0*t)+a2*cos(2*w0*t)+b2*sin(2*w0*t)+a4*cos(4*w0*t);
%note that a wmax=4*w0=8rd/s which means that a sample pulse we must be
%>=2*wmax , we>= 16rd/s, then pas<= 2pi/16 (Shanon theorem)
plot(t,y);
[wc,w0,a0,ak,bk,c0,ck]=get_harmonics(y,pas);
figure;
stem(wc,abs(ck));
xlabel('pulse w(rd/s)');
ylabel('abs(C_k)')
title ('Amplitude spectrum')
[a0 ak(1:5) bk(1:5)]
%check the ak and bk
