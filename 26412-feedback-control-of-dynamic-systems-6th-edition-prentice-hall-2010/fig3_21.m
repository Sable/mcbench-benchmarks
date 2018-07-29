%  Figure 3.21     Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
% script to generate Fig. 3.21
% fig3_21.m 
clf;
num=[2 1];    % form transfer function
den=[1 2 5];
sys=tf(num,den); % form system
t=0:.1:6;        % define time vector
y=impulse(sys,t); % compute impulse response
plot(t,y,'LineWidth',2)
hold on
% compute 2e^(-t)
ne=2;
de=[1 1];
syse=tf(ne,de);
ye=impulse(syse,t);
plot(t,ye,':r','LineWidth',2)
plot(t,-ye,':r','LineWidth',2),
axis([0 6 -2 2])
hold off
title('Figure 3.21')
xlabel('Time (sec)')
ylabel('h(t)')
% grid
nicegrid