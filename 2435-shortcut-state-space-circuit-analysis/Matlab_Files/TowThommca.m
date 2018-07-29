% Main program for MCA of Tow Thomas Bandpass Filter using DS Method
% File: c:\M_files\short_updates\TowThommca.m
% updated 11/19/06
tic;clear;clc;
%
K=1e3;uF=1e-6;
% Component values
R1=200*K;R2=10*K;R3=20*K;R4=10*K;R5=20*K;R6=20*K;
C1=0.0159*uF;C2=C1;
%
Nom=[R1 R2 R3 R4 R5 R6 C1 C2]; % Component vector
Tr=0.02;Tc=0.1; % 2% resistors; 10% capacitors 
%
% Tolerance array T; minus in row 1, plus in row 2
% Column order follows component vector Nom
%
T=[-Tr -Tr -Tr -Tr -Tr -Tr -Tc -Tc;Tr Tr Tr Tr Tr Tr Tc Tc]; 
%
% Linear sweep frequency parameters: BF = Beginning Frequency in Hz, LF = Last Frequency
% DF = Frequency increment, Lit = Last iteration or number of points
%
BF=700;LF=1300;NP=101;
F=linspace(BF,LF,NP);
%   
Nc=length(Nom); % Nc = number of components.
%
[A,B,D,E,I]=ttbpf(Nom); % Arrays using nominal component values
%
% Arrays are constant and real, and they are calculated only once,
% not at each frequency as in admittance matrix analyses.  
% This reduces run times considerably.
%
% Nominal output
%
for i=1:NP
   s=2*pi*F(i)*j;
   Vn(i)=abs(D*((s*I-A)\B)+E); 
end
%
% MCA output
%
Nk=2000; % <<<<<<<<<<<<<<<<<<<<< Nk
%  
Vm1=zeros(Nk,NP);Vm2=Vm1; % Create space for output
%
rand('state',sum(200*clock)); %  Randomize seed for uniform distribtution
randn('state',sum(200*clock)); % Randomize seed for normal distribution
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
   %
   Runif(k,:)=Nom.*(tr1.*RU(k,:)+tr2);
   Rnorm(k,:)=Nom.*((tr1/6).*(RN(k,:)+3)+tr2);
   %
   [Au,Bu,Du,Eu]=ttbpf(Runif(k,:)); % Arrays randomized by Runif
   [An,Bn,Dn,En]=ttbpf(Rnorm(k,:)); % Arrays randomized by Rnorm
   %
   for i=1:NP
      s=2*pi*F(i)*j;
      Vm1(k,i)=abs(Du*((s*I-Au)\Bu)+Eu); % Uniform distribution
      Vm2(k,i)=abs(Dn*((s*I-An)\Bn)+En); % Normal distribution
   end % close frequency loop i
end % close MCA loop k
%
Vmax1=max(Vm1);Vmin1=min(Vm1);  % Get envelopes of extrema.
Vmax2=max(Vm2);Vmin2=min(Vm2);
%
% Plot output
%
h=plot(F,Vmax1,'r',F,Vmin2,'b',F,Vn,'k--'); % For linear freq sweep.
set(h,'LineWidth',2);grid on
hold on
h=plot(F,Vmax2,'b',F,Vmin1,'r');
set(h,'LineWidth',2);
hold off
axis auto
xlabel('Freq (Hz)');ylabel('Volts');
title('TTBPF MCA - Uniform & Normal Dist')
legend('Uniform','Normal','Nominal');
text(805,8.2,['Nk = ',num2str(Nk)],'FontSize',8);
figure(1)
ET=toc




