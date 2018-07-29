%  Figure 3.32      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
% script to generate Fig. 3.32
% Pole-zero effects
%
close all;
clear all;
Den1=[1 0.2 1.01];
Den2=[1 1.0];
Den11=conv(Den1,Den2);
alpha=0.1;
beta=1.0;
Num1=(1.01*1.0/(alpha^2+beta^2))*([1 2*alpha alpha^2+beta^2]);

t=0:.1:20;
sys=tf(Num1,Den11);
[y1]=step(sys,t)

Den1=[1 0.2 1.01];
Den2=[1 1.0];
Den22=conv(Den1,Den2);
% alpha=1;
alpha1=0.25;
beta=1.0;
Num2=(1.01*1.0/(alpha1^2+beta^2))*([1 2*alpha1 alpha1^2+beta^2]);

t=0:.1:20;
sys2=tf(Num2,Den22);
[y2]=step(sys2,t)

Den1=[1 0.2 1.01];
Den2=[1 1.0];
Den33=conv(Den1,Den2);
alpha2=0.5;
beta=1.0;
Num3=(1.01*1.0/(alpha2^2+beta^2))*([1 2*alpha2 alpha2^2+beta^2]);

t=0:.1:20;
sys2=tf(Num3,Den33);
[y3]=step(sys2,t)
plot(t,y1,t,y2,t,y3);
xlabel('Time (sec)');
ylabel('Unit step response');
text(2, 1.36, '\alpha = 0.5');
text(2,1.14,'\alpha = 0.25');
text(2,0.8,'\alpha = 0.1');
title('Fig. 3.32: Step responses');
%%%%%%%%%%%%%%%%%%%%%

%grid
nicegrid





