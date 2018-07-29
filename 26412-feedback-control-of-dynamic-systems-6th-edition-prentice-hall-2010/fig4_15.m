%  Figure 4.15     Feedback Control of Dynamic Systems, 6e
%                   Franklin, Powell, Emami
%% script to generate Figure 4.15
% case I, P control by reaction curve data.
% First, input the plant model and compute the reaction curve.
sysp=tf(1,[600 70 1])
set(sysp,'td', 5)
figure(1)
clf
step(sysp)
title('Figure 4.15 Reaction Curve for the Heat Exchanger')
nicegrid
