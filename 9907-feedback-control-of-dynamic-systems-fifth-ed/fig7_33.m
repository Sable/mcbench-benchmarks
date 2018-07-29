%  Figure 7.33      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
% fig7_33.m  
clf;
f=[0 1;-1 0];
g=[0;1];
h=[1 0];
K=[3 4];
fc=f-g*K;
gc=[4*g [1;0]];
hc=[h;[0 1]; -K/4];
jc=[0 0;0 0; 1 0];
A=[fc [0;0]; -101*h-K -10];
B=[0 1;4 0;4 0];
C=eye(3);
C(3,1) = 10;
D=[0 0;0 0;0 0];
t=0:.1:4;
[y]=impulse(A,B,C,D,2,t);
plot(t,y);
grid;
xlabel('Time (sec)');
ylabel('Amplitude');
text(.2,3,'x_2hat');
text(.75,1,'x_1');
text(.25,-1,'x_2');
title('Fig.7.33  Initial condition response with reduced order estimator')

