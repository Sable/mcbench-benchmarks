% Fig. 2.3  Feedback Control of Dynamic Systems, 6e 
%            Franklin, Powell, Emami
%

clear all;
close all;
clf
hold off
num = 1/1000;
den = [1 50/1000];
sys = tf(num,den);
t = 0:100;
y = step(num*500,den,t);
plot(t,y),grid
xlabel('Time (sec)')
ylabel('Amplitude')
title('Fig. 2.3')
nicegrid