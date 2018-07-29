%  Figure 7.79      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
% script to generate Fig. 7.79
%% fig7_79.m
%% Heat Exchanger
clf;
[t]=sim('fig7_78cl');
plot(t,y);
grid;
title('Fig. 7.79: Open and Closed-loop responses for heat exchanger');
text(50,1.2,'Closed-loop');
xlabel('Time (sec)');
ylabel('Output Temperature, y');
hold on;
[t1]=sim('fig7_78ol');
plot(t1,yol,'g');
text(50,0.4,'Open-loop');
nicegrid;
hold off;




