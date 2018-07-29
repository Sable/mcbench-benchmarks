% Fig. 7.2  Feedback Control of Dynamic Systems, 6e 
%            Franklin, Powell, Emami
% script to generate Fig. 7.2

clear all;
close all;

F = [0 1; 0 -0.05];
G = [0; 0.001];
H = [0 1];
J = 0;
sys=ss(F,500*G,H,J);
step(sys);
title('Fig. 7.2: Response of car velocity to a step in u');
nicegrid;

