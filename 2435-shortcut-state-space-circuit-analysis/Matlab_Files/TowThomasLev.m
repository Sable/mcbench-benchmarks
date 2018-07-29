% Tow Thomas Biquad Bandpass Filter - Leverriers Algorithm
% File:  TowThomasLev.m
% 9/22/02
clc;clear;format short g;
K=1e3;uF=1e-6;
R1=200*K;R2=10*K;R3=20*K;R4=10*K;R5=20*K;R6=20*K;
C1=0.0159*uF;C2=C1;
X=[R1 R2 R3 R4 R5 R6 C1 C2]; % Put components in vector form
%
[A,B,D,E]=tow(X); 
%
% Uncomment following two lines to output arrays to text file qbout.txt
%fid=fopen('c:\M_files\qbout.txt','w'); % Use local directory
%diary c:\M_Files\qbout.txt; % Use local directory
A
B
D
E
%
% Display results of Leverrier's Algorithm
%
F1=eye(2);T1=-trace(A*F1)/1
F0=A*F1+T1*F1
T0=-trace(A*F0)/2
Y1=D*F1*B+E*T1
Y0=D*F0*B+E*T0
%
% Uncomment the following two lines to close text file.
%diary off
%status=fclose(fid);
%
% Get frequency sweep; BF = Beginning (Log) Frequency, ND = Number of Decades
% PD = Points per Decade
BF=2;ND=2;PD=50;Lit=ND*PD+1;L=linspace(BF,BF+ND,Lit);
for i=1:Lit
   F=10^L(i);s=2*pi*F*j;
   for k=1:3 % Get all three transfer functions from transfer matrix
      num=E(k)*s^2+Y1(k)*s+Y0(k);
      den=s^2+T1*s+T0;
      Vo(k,i)=20*log10(abs(num/den));
   end
end
%
% Plot Vo
%
h=plot(L,Vo(1,:),'k',L,Vo(2,:),'r',L,Vo(3,:),'b');
set(h,'LineWidth',2);
grid on
xlabel('Log Freq(Hz)');
ylabel('dBV');
title('Transfer Matrix Outputs');
legend('V2','V4','V6');
figure(1);


   

