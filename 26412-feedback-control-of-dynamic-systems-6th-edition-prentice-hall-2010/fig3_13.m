%  Figure 3.13      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
% script to generate Fig. 3.13
%  fig3_13.m      
clf;
einv=1/exp(1);
num=1;
den=[1 1];
t=0:.05:4;
y=impulse(num,den,t);

% define some lines for the plot
tl=[0 1];
yl=[1 0];
t1=[1 1];
y1=[0 einv];
t2=[0 1];
y2=[einv einv];
figure();
plot(t,y,'-',tl,yl,'--',t1,y1,':',t2,y2,':','LineWidth',2)
title('Fig. 3.13(a) First order system impulse response')
xlabel('Time (sec)')
ylabel('h(t)')
text(0.7,0.6,'e^{-\sigmat}');
text(1.1,0.3679,'\leftarrow 1/e');
text(1,0.05,'\downarrow t= \tau');
% grid
nicegrid
pause;
% Figure 3.13 (b)
a=1;
num=[a];              % form numerator
den=[1 a];            % form denominator
t=0:0.01:4;           % form time vector
sys=tf(num,den);      % form system
h=impulse(sys,t);     % compute impulse response
figure();
plot(t,h);            % plot impulse response
y=step(sys,t);        % compute step response
hold
plot(t,y,'LineWidth',2);            % plot step response
xlabel('Time (sec)');
ylabel('h(t),y(t)');
title('Fig. 3.13(b) Impulse and step responses');
text(2,0.8,'y(t)');
text(2,0.2,'h(t)');
% grid
nicegrid