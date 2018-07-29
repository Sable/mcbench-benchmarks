% Frequency response Magnet Driver circuit network using DS method
%  and G array.
% File:  c:\M_files\short_updates\UsingGarray1.m
% 02/10/07
% See Word file UsingGarray1.doc for background explanations.
clear;clc; 
% unit suffixes
u=1e-6;K=1e3;m=1e-3;u=1e-6;p=1e-12;
% component values
R1=5*K;R2=1*K;R3=10*K;
C1=0.1*u;C2=400*p;
Ein=1; % Unity input for (normalized) transfer function
N=2; % Number of capacitors = order of circuit
%
% Form W, Q, S, and P arrays: 
%
W=[1+R3/R1 1+R3/R1;R2 0];Q=[0 -1/R1;-1 1];S=[Ein/R1;0];P=diag([C1 C2]);
%
% Get A, B, D, & E arrays:
%
C=inv(W*P);A=C*Q;B=C*S;
% D & E from the first output equation:
D1=[0 R1/(R1+R3)];E1=R3/(R1+R3);
% D & E from the second (easier) output equation:
D2=[0 1];E2=0;
%
% Now we can form the G array = F*P as follows.
%
F=[R3 R3]; % R3 is the coefficient of both iC1 and iC2 in Vo2 
% which are derivative terms (iC=dVc/dt, etc.)   
G=F*P;
%
% * * * * * * * * * * * * Frequency response * * * * * * * * * * * *
%
I=eye(N); % identity matrix
%
% Log frequency sweep from BF to BF+ND
%
BF=0;ND=4;PD=25;NP=ND*PD+1;Fr=logspace(BF,BF+ND,NP);
for i=1:NP
   s=2*pi*Fr(i)*j; % j = sqrt(-1)
   stm=(s*I-A)\B;v1=abs(D1*stm+E1);Vo1(i)=20*log10(v1);
   v2=abs((D2+G*A)*stm+E2+G*B);Vo2(i)=20*log10(v2);  
end
%
% Plot frequency (Vo1 & Vo2 separated by 0.2 dBV to ovoid overlay)
%
h=plot(log10(Fr),Vo1-0.2,'b',log10(Fr),Vo2,'r');
set(h,'LineWidth',2);
grid on;
axis auto
ylabel('dBV');title('Magnet Driver Output');
xlabel('Log Freq(Hz)');
legend('Vo1 - 0.2','Vo2 using G array');
figure(1);
%
