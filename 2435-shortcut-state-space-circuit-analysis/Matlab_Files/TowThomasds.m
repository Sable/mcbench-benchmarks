% Tow Thomas Biquad Bandpass Filter - Three outputs from one analysis.
% File: c:\M_files\short_updates\TowThomasds.m
% updated 11/16/06
clc;clear
K=1e3;uF=1e-6;
R1=200*K;R2=10*K;R3=20*K;R4=10*K;R5=20*K;R6=20*K;
C1=0.0159*uF;C2=C1;
%
Nom=[R1 R2 R3 R4 R5 R6 C1 C2]; % Put components in vector form
%
[A,B,D,E,I]=tow(Nom); % executed only once, not at every frequency as
% is required using complex admittance matrix methods.  Another advantage is that
% the A, B, D, E arrays are real.  This makes execution must faster.
%
% Log frequency sweep
% BF = Beginning (Log) Frequency, ND = Number of Decades
% PD = Points per Decade, NP = number of points.
%
BF=2;ND=2;PD=50;NP=ND*PD+1;L=linspace(BF,BF+ND,NP);
for i=1:NP
   F=10^L(i);s=2*pi*F*j;
   cv=abs(D*((s*I-A)\B)+E);
   Vm=20*log10(cv);
   % Get outputs V2, V4, & V6 from Vm
   V2(i)=Vm(1);V4(i)=Vm(2);V6(i)=Vm(3); 
end
%
% Plot Vo
%
h=plot(L,V2,'k',L,V4,'r',L,V6,'b');
set(h,'LineWidth',2);
grid on;axis auto;
xlabel('Log Freq(Hz)');
ylabel('dBV');
title('Three outputs');
legend('V2','V4','V6');
figure(1);


   

