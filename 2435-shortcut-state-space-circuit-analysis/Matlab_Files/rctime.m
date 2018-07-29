% Simple 1st order RC transient response:
% File:  rctime.m
% 9/19/02
%
clear;clc
%
K=1e3;uF=1e-6;us=1e-6;ms=1e-3;
%
R1=20*K;R2=40*K;C1=0.5*uF;Ein=1;E1=1;
%
U=1;N=1;M=1;Y=1;
%
A1=[1/R1+1/R2 1;1 0];
%
B2=[0 Ein/R1;E1 0];
%
P=C1;
%
% Template matrix equations:
%
V=A1\B2;H=V(U+1:U+N,1:N+M);AB=inv(P)*H;I=eye(N);

A=AB(1:N,1:N);B=AB(1:N,N+1:N+M);
D=V(Y:Y,1:N);E=V(Y:Y,N+1:N+M);
%
% Display A, B, D, & E
A
B
D
E
%
Rp=R1*R2/(R1+R2);
dt=500*us;kmax=100;Ein=4.5; % Ein can be changed after A, B, D, E have been computed.
%dt=100*us;kmax=500;Ein=4.5; % Try this dt after using the dt above.
Vc=zeros(1,kmax);Vo=zeros(1,kmax); % Vo(k) = Vc(k);
%
for k=2:kmax
   Vc(k)=(A*Vc(k-1)+B*Ein)*dt+Vc(k-1);
   Vo(k)=D*Vc(k)+E*Ein;
   T(k)=k*dt;
   F(k)=(Ein*Rp/R1)*(1-exp(-T(k)/(Rp*C1))); % F(k) = inverse LaPlace tranform 
end
%
h=plot(T/ms,Vo,'k',T/ms,F,'r');
set(h,'LineWidth',2);
grid on
xlabel('Time (ms)');
ylabel('Volts');
title('RC Time Response');
legend('Vo(k)','F(k)');
figure(1);
%
% Note that difference between F(k) and the time iteration Vo(k).  This can be reduced by 
% decreasing dt with a corresponding increase in kmax to retain the same sweep time.
% For example, if dt = 250us, kmax should be set to 200.




