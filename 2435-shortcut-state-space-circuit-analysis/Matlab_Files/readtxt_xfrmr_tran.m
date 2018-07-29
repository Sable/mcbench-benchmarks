% Test file read
% File:  c:\M-files\shortcut_updates\readtxt_TwinT.m
% 2/15/07
%
clc;clear;
ns=1e-9;
[time,v1,v3]=textread('c:\Spiceapps\datfiles\xformer_tran.txt','%f %f %f');
%
h=plot(time/ns,v1,'k',time/ns,v3,'r');
set(h,'LineWidth',2);
axis([0 200 -5 15]);
grid on
xlabel('Time (ns)');
ylabel('Volts');
title('Transformer Pulse Response');
legend('V1','V3',0);
figure(1)
%





