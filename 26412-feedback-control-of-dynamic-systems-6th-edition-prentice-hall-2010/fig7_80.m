%  Figure 7.80      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
% script to generate Fig. 7.80
%% fig7_80.m 
%% Heat Exchanger
clf;
[t]=sim('Fig7_78cl');
plot(t,u);
title('Fig. 7.80: Control effort for heat echanger');
xlabel('Time (sec)');
ylabel('Control, u');
nicegrid;





