% Test file read
% File:  c:\M-files\shortcut_updates\readtxt_TwinT.m
% 2/14/07
%
clc;clear;
ms=1e-3;
[time,v99,v2,v991,v31,v3]=textread('c:\Spiceapps\datfiles\TwinTran.txt','%f %f %f %f %f %f');
%
h=plot(time/ms,v99,'k--',time/ms,v2,'r',time/ms,v991,'b',time/ms,v31,'g');
set(h,'LineWidth',2);
axis([0 80 -0.2 1.2]);
grid on
xlabel('Time (ms)');
ylabel('Volts');
title('Twin Tee Pulse Response');
legend('Input Pulse','VC2','VC4','VC6',0);
figure
%
h=plot(time/ms,v99,'k--',time/ms,v3,'r');
grid on
axis([0 80 -0.2 1.2]);
set(h,'LineWidth',2);
xlabel('Time (ms)');
ylabel('Volts');
title('Twin Tee Pulse Response');
legend('Input Pulse','Output at V3',0);






