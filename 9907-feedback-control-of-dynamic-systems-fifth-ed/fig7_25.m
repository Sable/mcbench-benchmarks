%  Figure 7.25      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
% Script for pendulum LQR
%
clf;
wo=1;
F=[0 1;wo*wo 0];
G=[0;-1];
Hz=[2 1];
J=[0];

R=1;
Q=Hz'*Hz;

K=lqr(F,G,Q,R);

eig(F-G*K)

%step response
%%N=-2.2361;
H=[1 0];

aa=[F G;H J];
bb=[0;0;1];
xx=aa\bb;
Nx=xx(1:2,:);
Nu=xx(3,:);
Nbar=Nu+K*Nx;
FCL=F-G*K;
GCL=G*Nbar;
sys=ss(FCL,GCL,H,J);
[y,t]=step(sys);
plot(t,y);
grid
xlabel('Time (sec)');
ylabel('Position, x_1');
title('Fig. 7.25 Step response pendulum: LQR design');

