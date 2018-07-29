% Main program for ac Monte Carlo Analysis (MCA) of Multiple Feedback Bandpass Filter
% File: c:\M_files\short_updates\mfpbmca.m
% updated 11/19/06
clear;clc;tic;
R1=6340;R2=80.6;R3=127000;C1=0.1*1e-6;C2=C1;
%
Nom=[R1 R2 R3 C1 C2];
Tr=0.02;Tc=0.1; % 2% resistors, 10% capacitors
% Tolerance array T; minus in row 1, plus in row 2
% Column order follows component vector X
%
T=[-Tr -Tr -Tr -Tc -Tc;Tr Tr Tr Tc Tc];
%
% Linear sweep frequency parameters: BF = Beginning Frequency (Hz), LF = Last Frequency
%
BF=400;LF=600;NP=101; % NP = number of points
F=linspace(BF,LF,NP);
%   
Nc=length(Nom); % Nc = number of components.
%
[A,B,D,E,I]=bpf1(Nom); % Arrays using nominal component values
%
% Arrays are constant and real, and they are calculated only once
% per frequency sweep, not at each frequency as in admittance matrix analyses.  
% This reduces run times considerably.
%
% Nominal output; one freq sweep; not a function of k samples;
%   keep separate from Nk loop.
%
for i=1:NP;s=2*pi*F(i)*j;Vn(i)=abs(D*((s*I-A)\B)+E);end;
%
% MCA output
%
Nk=2000; % number of MCA samples.  
% Rule of thumb:  Nk should be a minimum of 1000. 
%
Vm1=zeros(Nk,NP);Vm2=Vm1; % Create space for output
%
rand('state',sum(200*clock)); %  Randomize seed for uniform distribtution input
randn('state',sum(200*clock)); % Randomize seed for normal distribution input
%
RU=rand(Nk,Nc); %  Random {Nk Nc} array - uniform distribution
RN=randn(Nk,Nc); % Random {Nk Nc} array - normal distribution
%
% Get tolerance array constants that do not vary with k samples
%
p=1:Nc;tr1=T(2,:)-T(1,:);tr2=T(1,:)+1;
%
for k=1:Nk
%
% Convert random numbers to random component tolerances
% Get one kth row with Nc columns from random arrays RU and RN (dim {Nk Nc})
%
   Ru(k,:)=Nom.*(tr1.*RU(k,:)+tr2);
   Rn(k,:)=Nom.*((tr1/6).*(RN(k,:)+3)+tr2);
%
   [Au,Bu,Du,Eu]=bpf1(Ru(k,:)); % Arrays randomized by RU
   [An,Bn,Dn,En]=bpf1(Rn(k,:)); % Arrays randomized by RN
   %
   for i=1:NP
      s=2*pi*F(i)*j;
      Vm1(k,i)=abs(Du*((s*I-Au)\Bu)+Eu);% Uniform distribution
      Vm2(k,i)=abs(Dn*((s*I-An)\Bn)+En); % Normal distribution
      %
   end % close frequency loop i
end % close MCA loop k
Vmax1=max(Vm1);Vmin1=min(Vm1);  % Get envelopes of extrema.
Vmax2=max(Vm2);Vmin2=min(Vm2);
%
% Plot output
%
h=plot(F,Vmax1,'r',F,Vmax2,'b',F,Vn,'k--'); % For linear freq sweep.
set(h,'LineWidth',2);grid on
hold on
h=plot(F,Vmin1,'r',F,Vmin2,'b');
set(h,'LineWidth',2);
set(gca,'FontSize',8);
hold off;axis auto
xlabel('Freq (Hz)');ylabel('Volts');
title('BPF MCA - Uniform & Normal Dist') 
legend('Uniform','Normal','Nominal')
text(410,8.2,['Nk = ',num2str(Nk)],'FontSize',8);
figure(1)
ET=toc
%
% Note that there are no "gaps" at about 475 and 525 Hz as in FMCA.  Hence MCA is
% strongly recommended, make that required, for circuits with bipolar sensitivities, 
% such as bandpass, bandstop, notch, high-Q low and high pass filters.



