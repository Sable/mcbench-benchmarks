%  Figure 7.30      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
% script to generate Fig. 7.30
% fig7_30.m
clf;
f=[0 1;-1 0];
g=[0;1];
h=[1 0];
K=[3 4];
fc=f-g*K;
gc=[4*g [1;0]];
hc=[h;[0 1]; -K/4];
jc=[0 0;0 0; 1 0];
l=[20;99];
A=[fc, 0*fc;l*h-g*K, f-l*h];
B=[0 1;4 0;0 0;4 0];
C=eye(4);
D=[0 0;0 0;0 0;0 0];
t=0:.03:4;
sys=ss(A,B,C,D);
[y]=impulse(sys,t);
plot(t,y(:,:,2),'LineWidth',2);
xlabel('Time (sec)');
ylabel('Amplitude');
text(.25,2,'$$\mathsf{\hat x_2}$$','interpreter','latex','FontSize',10,'FontName','Helvetica');
text(.5,1,'$$\mathsf{\hat x_1}$$','interpreter','latex');
text(.15,.8,'x_1');
text(.25,-.5,'x_2');
title('Fig.7.30 Initial condition response of oscillator with estimator')
nicegrid;

