% Frequency response 3rd Order Bessel HPF
%  and G array.
% File:  c:\M_files\short_updates\UsingGarray2.m
% 02/10/07
% See Word file UsingGarray2.doc for schemtic and equations.
clear;clc; 
% unit suffixes
u=1e-6;K=1e3;m=1e-3;u=1e-6;n=1e-9;p=1e-12;
% component values
R1=52*K;R2=75*K;R3=287*K;
C1=1.55*n;C2=C1;C3=C1;
Ein=1; % Unity input for (normalized) transfer function
N=3; % Number of capacitors = order of circuit
%
% Form W, Q, S, and P arrays: 
%
W=[R2 -R2 0;0 R1 R3-R1;0 0 R3];
Q=-[1 0 0;1 1 0;1 1 1];S=Ein*[1;1;1];P=diag([C1 C2 C3]);
%
% Get A, B, D, & E arrays:
%
C=inv(W*P);A=C*Q;B=C*S;
% D & E 
D=[0 0 0];E=0;
%
F=[0 0 R3]; % R3 is the coefficient of both iC1 and iC2 in Vo2 
% which are derivative terms (iC=dVc/dt, etc.)   
G=F*P;
%
% * * * * * * * * * * * * Frequency response * * * * * * * * * * * *
%
I=eye(N); % identity matrix
%
% Log frequency sweep from BF to BF+ND
%
BF=2;ND=2;PD=50;NP=ND*PD+1;Fr=logspace(BF,BF+ND,NP);
for i=1:NP
   s=2*pi*Fr(i)*j; % j = sqrt(-1)
   stm=(s*I-A)\B;
   v2=abs((D+G*A)*stm+E+G*B);Vo(i)=20*log10(v2);
   asym(i)=60*log10(Fr(i)/1000); % +60 dB/decade slope
end
%
h=plot(log10(Fr),Vo,'r',log10(Fr),asym,'k--');
set(h,'LineWidth',2);
grid on;
axis([2 4 -60 20]);
ylabel('dBV');title('Bessel HPF');
xlabel('Log Freq(Hz)');
legend('Vo','Asymptote');
figure(1);
%
