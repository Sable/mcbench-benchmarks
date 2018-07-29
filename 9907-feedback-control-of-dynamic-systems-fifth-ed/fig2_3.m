% Fig. 2.3  Feedback Control of Dynamic Systems, 5e 
%            Franklin, Powell, Emami
%

clear all;
close all;

F = [0 1; 0 -.05]
G = [0; .001]
H = [0 1]
J = 0;
t = 0:100;
y = step(F,500*G,H,J,1,t);
plot(t,y),grid
xlabel('Time (sec)')
ylabel('Amplitude')
title('Fig. 2.3')
