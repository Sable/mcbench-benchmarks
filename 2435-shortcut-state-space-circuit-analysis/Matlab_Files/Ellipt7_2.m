% 7th Order Elliptical Filter frequency response.
% File:  Ellipt7_2.m
% Updated 10/09/02
%  
clc;clear;tic; % start timer
K=1e3;nF=1e-9;% unit suffixes
%
% Component values
%
R1=19.6*K;R2=196*K;R3=1*K;R4=147*K;R5=71.5;R6=37.4*K;R7=154*K;
R8=110*K;R9=260;R10=740;R11=402;R12=27.4*K;R13=110*K;R14=40;R15=960;
C1=2.67*nF;C2=C1;C3=C1;C4=C1;C5=C1;C6=C1;C7=C1;
%
% To change corner frequency, change the value of C1 thru C7
%
Xr=[R1 R2 R3 R4 R5 R6 R7 R8 R9 R10 R11 R12 R13 R14 R15];
Xc=[C1 C2 C3 C4 C5 C6 C7];
%
[A,B,D,E,I]=E7x(Xr,Xc); % Get arrays for analysis below
%
% * * * * * * * * * * * * Frequency response * * * * * * * * * * * *
%
% Log frequency sweep.  BF = log Beginning Frequency = 10^BF
% ND = Number of Decades, PD = Points per Decade
% NP = number of points; here = 201.
%
BF=2;ND=2;PD=100;NP=ND*PD+1;L=linspace(BF,BF+ND,NP);
for i=1:NP
   F=10^L(i);s=2*pi*F*j; % j = sqrt(-1)
   Vg=abs(D*((s*I-A)\B)+E);Vf(i)=20*log10(Vg); 
   Va(i)=-210*log10(F/1000); % slope of asymptote is -210 dB/decade for a 7th order circuit.
end
%
% Plot frequency 
%
h=plot(L,Vf,'k',L,Va,'k--');
set(h,'LineWidth',2);
grid on;
axis([BF BF+ND -80 40]);
XT=linspace(BF,BF+ND,11);
set(gca,'xtick',XT);
ylabel('dBV');title('7th Order Elliptical LPF');
xlabel('Log Freq(Hz)');
legend('LPF Output','Asymptote');
figure(1); % display plot
ET=toc