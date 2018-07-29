% Fig. 7.2  Feedback Control of Dynamic Systems, 5e 
%            Franklin, Powell, Emami
%

clear all;
close all;

F = [0 1; 0 -0.05];
G = [0; 0.001];
H = [0 1];
J = 0;
sys=ss(F,500*G,H,J);
step(sys);
grid;
title('Fig. 7.2')
