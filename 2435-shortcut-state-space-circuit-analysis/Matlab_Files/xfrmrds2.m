% MATLAB computation of pulse transformer model - DS Method
% File:  c:\M_files\shortcuts\xfrmrds2.m
% 9/19/02; 4/17/04; 2/15/07
%   
tic;clc;clear;
K=1e3;pF=1e-12;mH=1e-3;uH=1e-6;ns=1e-9;ps=1e-12; % unit suffixes
%
% Components
%
R1=10;R2=1.5;R3=20*K;R4=1.5;R5=1*K;R6=0.5;R7=1;
C1=20*pF;C2=5*pF;C3=20*pF;L1=1*uH;L2=2*mH;L3=1*uH;
%
% Get A, B, D, & E arrays; this function called only once.
%
Nom=[R1 R2 R3 R4 R5 R6 R7 C1 C2 C3 L1 L2 L3];
[A,B,D,E,I]=tfrmr2(Nom);
%
% * * * * * * * * * * * * Frequency response * * * * * * * * * * * *
%
Ein=10; % Change Ein from 1V to 10V.
%
BF=2;ND=6;PD=50;NP=ND*PD+1;L=linspace(BF,BF+ND,NP);
%
% Since the output is vC3, we dont need the D and E arrays. 
% The cv output below is [vC1 vC2 vC3 iL1 iL2 iL3]'
% (a column vector).  Hence we need vC3 or cv(3).
%
for i=1:NP
   F=10^L(i);s=2*pi*F*j;
   cx=(s*I-A)\B*Ein;
%   cy=D*cx+E*Ein; % cy not used 
   Vo=abs(cx(3)); % vC3 = Vo
   Vf(i)=20*log10(Vo); 
end
%
% * * * * * * * * * * * * * Transient response * * * * * * * * * * * 
%
Tx=1/max(max(abs(A)));
disp('Shortest circuit time constant');Tx
%Per=input('Sweep time? (sec)');
% set Sweep time to 200ns = 200e-9 to match Spice run.
Per=200*ns;
kmax=1e5; % kmax increased due to fast time constant Tx
dt = 2*ps
N=6;
%dt=Per/kmax;N=6;
t1=linspace(0,Per,kmax);IV=zeros(N,kmax);
%
% input ramp parameters
%
p=Ein/(5*dt);b=6*dt;pw=5e4*dt;c=pw+6*dt;d=pw+11*dt;
Ea1=ramp1(p,t1(1),dt)-ramp1(p,t1(1),b)-ramp1(p,t1(1),c)+ramp1(p,t1(1),d);
% initialize k = 1
IV(:,1)=B*Ea1*dt;
%
% iterate for k = 2,3,...kmax
%
for k=2:kmax
   Eak=ramp1(p,t1(k),dt)-ramp1(p,t1(k),b)-ramp1(p,t1(k),c)+ramp1(p,t1(k),d);
   IV(:,k)=A*IV(:,k-1)*dt+B*Eak*dt+IV(:,k-1);
end
%
% Plot frequency response
%
subplot(2,1,1)
h=plot(L,Vf,'k');
set(h,'LineWidth',2);
grid on;
axis([BF BF+ND -40 30]);
XT=linspace(BF,BF+ND,7);
set(gca,'xtick',XT);
ylabel('dBV');title('AC Output Vc3');
xlabel('Log Freq(Hz)');
%
% Plot time response
%
subplot(2,1,2)
h=plot(t1/ns,IV(1,:),'k',t1/ns,IV(3,:),'r');
set(h,'LineWidth',2);
axis auto
grid on;ylabel('Volts');title('Transient response, Vc1 & Vc3');
xlabel('nsec');
legend('Vc1','Vc3');
figure(1) % display plot on screen.
%
disp(' ');disp('Execution time in seconds');
ET=toc
 





