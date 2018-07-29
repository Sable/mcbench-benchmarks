%  Figure 3.4      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
% script to generate Fig. 3.4
%% fig3_04.m    Example 3.5
clf;
k=1;
num=1;                        % form numerator
den=[1 k];                    % form denominator
% sinusoidal input signal
deltaT = 0.001;
t=0:deltaT:10;                % form time vector
u=sin(10*(t));                % form input
sys=tf(num,den);              % form system
[y]=lsim(sys,u,t);            % linear simulation
% plot response
figure();
plot(t,y);
xlabel('Time (sec)');
ylabel('Output');
title('Fig. 3.4 (a): transient response');
pause;
hold on;
y1=(10/101)*exp(-t);
phi=atan(-10);
y2=(1/sqrt(101))*sin(10*t+phi);
plot(t,y1,t,y2,t,y1+y2);
% grid
nicegrid
hold off;
pause;
figure();
ii=[9001:10001];
plot(t(ii),y(ii),t(ii),u(ii));
xlabel('Time (sec)');
ylabel('Output, input');
title('Fig. 3.4 (b): Steady-state response');
text(9.4,0.65,'u(t)');
text(9.24,0.12,'y(t)');
% grid
nicegrid
