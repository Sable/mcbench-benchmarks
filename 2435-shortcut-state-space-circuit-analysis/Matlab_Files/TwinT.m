% Frequency and transient response of Twin Tee network using DS method
% File:  c:\M_files\short_updates\TwinT.m
% updated 11/16/06
clear;clc; 
% unit suffixes
uF=1e-6;K=1e3;ms=1e-3;us=1e-6;Meg=1e6;
% component values
R1=267*K;R3=R1;R5=133*K;R7=10*Meg;
C2=0.02*uF;C4=0.01*uF;C6=C4;
%
Nom=[R1 R3 R5 R7 C2 C4 C6];
%
[A,B,D,E,I]=twt(Nom); % Get arrays
%
% * * * * * * * * * * * * Frequency response * * * * * * * * * * * *
%
% The following is used for linear frequency sweep from BF to LF Hz 
% in DF increments.
%
BF=0;LF=100;NP=101;F=linspace(BF,LF,NP);
for i=1:NP
   s=2*pi*F(i)*j; % j = sqrt(-1)
   Vg=abs(D*((s*I-A)\B)+E); 
   Vf(i)=20*log10(Vg); % in dBV   
end
%
% * * * * * * * * * * * * Time response * * * * * * * * * * * * * * *
% 
% Find delta time = dt
%
Tx=1/max(max(abs(A)));
format short
disp('Shortest circuit time constant');Tx
% dt specified here to match Spice run
dt=0.05*ms
kmax=1500;
% kmax = number of time increments;
% Total time sweep T = kmax*dt
T=kmax*dt;
t1=linspace(0,T,kmax);
N=3;Ein=1;
IV=zeros(N,kmax);Vo=zeros(1,kmax);
%
% initialize k = 1
%
% Input is from pulse(t,f,w,Ein); delayed to t = f, pulsewidth = w - f; ampl = Ein 
delay=0.05*T;pw=0.5*T;
Eapp(1)=pulse(t1(1),delay,pw,Ein);
IV(:,1)=B*Eapp(1)*dt;
%
% iterate for k = 2,3,...kmax
%
for k=2:kmax
   Eapp(k)=pulse(t1(k),delay,pw,Ein);
   IV(:,k)=A*IV(:,k-1)*dt+B*Eapp(k)*dt+IV(:,k-1);
   Vt(:,k)=D*IV(:,k)+E*Eapp(k);
end
%
% Plot frequency
%
h=plot(F,Vf,'k');
set(h,'LineWidth',2);
grid on;
axis auto
XT=linspace(BF,LF,6);
set(gca,'xtick',XT);
ylabel('Volts');title('AC Output Magnitude');
xlabel('Freq(Hz)');
figure
%
% Plot time responses
%
h=plot(t1/ms,IV(1,:),'r',t1/ms,IV(2,:),'b',t1/ms,IV(3,:),'g',t1/ms,Eapp,'k--');
set(h,'LineWidth',2);
grid on;ylabel('Volts');title('Across C2, C4, & C6');
xlabel('msec');
axis([0 80 -0.2 1.2]);
%YT=linspace(-1.2,1.2,13);
%set(gca,'ytick',YT);
legend('C2','C4','C6','Pulse');
figure
%
h=plot(t1/ms,Vt,'r',t1/ms,Eapp,'k--');
set(h,'LineWidth',2);
grid on;ylabel('Volts');xlabel('msec');
title('Output at R7');
axis([0 80 0 1.2]);
legend('Output','Input');


