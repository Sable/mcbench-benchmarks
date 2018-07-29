%  Figure 3.11      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%script to generate Fig. 3.11
%  fig3_11.m      
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
plot(t,y,'-',tl,yl,'--',t1,y1,':',t2,y2,':')
title('Fig. 3.11(a) First order system impulse response')
xlabel('Time (sec)')
ylabel('h(t)')
grid;
pause;
%%Figure 3.11 (b)
a=1;
num=[a];              % form numerator
den=[1 a];            % form denominator
t=0:0.01:4;           % form time vector
sys=tf(num,den);      % form system
h=impulse(sys,t);     % compute impulse response
plot(t,h);            % plot impulse response
y=step(sys,t);        % compute step response
grid;
hold
plot(t,y);            % plot step response
xlabel('Time (sec)');
ylabel('h(t),y(t)');
title('Fig. 3.11(b) Impulse and step responses');
text(2,0.8,'y');
text(2,0.2,'h');


