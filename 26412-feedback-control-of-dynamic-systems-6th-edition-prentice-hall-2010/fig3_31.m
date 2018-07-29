%  Figure 3.31      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
%script to generate Fig. 3.31
%Pole-zero effects
%
close all;
clear all;
Den1=[1 0.2 1.01];
Den2=[1 1.0];
Den11=conv(Den1,Den2);
alpha=0.1;
beta=1.0;
Num1=(1.01*1.0/(alpha^2+beta^2))*([1 2*alpha alpha^2+beta^2]);
alpha1=0.25;
alpha2=0.5;
pzmap(Num1,Den11)
axis('equal');
hold on;
plot(-alpha1,1.0,'o');
plot(-alpha1,-1.0,'o');
plot(-alpha2,-1.0,'o');
plot(-alpha2,1.0,'o');
axis([-1.5 0.5 -1.5 1.5]);
grid;




