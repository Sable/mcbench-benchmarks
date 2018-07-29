% Test file read
% File:  c:\M-files\shortcut_updates\readtxt.m
% 2/11/07
%
clc;clear;
[freq,mag,ph]=textread('c:\Spiceapps\datfiles\Elliptf7.txt','%f %f %f');
%
h=plot(log10(freq),20*log10(mag),'k');
set(h,'LineWidth',2);
hold on
% Plot -210 dB asymptote
h=plot(log10(freq),-210*log10(freq/1000),'k--');
hold off
axis([2 4 -80 40]);
set(h,'LineWidth',2);
grid on
xlabel('Log Freq(Hz)');
ylabel('dBV');
title('7th Order Elliptical LPF');
legend('Output','-210 dB Asymptote',0);
figure
%
h=plot(log10(freq),ph,'k');
grid on
xlabel('Log Freq(Hz)');
ylabel('Deg');
title('Elliptical LPF Phase');
axis([2 4 -200 200]);
set(h,'LineWidth',2);






