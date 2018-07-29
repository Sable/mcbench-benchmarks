% Monte Carlo Analysis (MCA) of all-pass filter using Normal and Uniform
%    distribution inputs
% File:  c:\M_files\short_updates\allpass2.m
% updated 11/19/06
% 
% This M-file provides phase angle output only - Nominal 90 degrees at 500 Hz.
%
tic;clc;clear;
K=1e3;uF=1e-6; % component unit suffixes
%
% Component values; design values for exactly 90 deg @ 500Hz.
%
R1=626.25;R2=22.55*K;R3=25.05*K;R4=225.45*K;C1=0.1*uF;C2=C1;
%
Nom=[R1 R2 R3 R4 C1 C2]; % component vector
%
% Component tolerances in decimal percent.
%
Tr=0.01;Tc=0.1; % 1% resistors, 10% capacitors.
%
% Tolerace array T; minus in row 1, plus in row 2.
%
T=[-Tr -Tr -Tr -Tr -Tc -Tc;Tr Tr Tr Tr Tc Tc]; % Order follows vector Nom
%
% Linear sweep frequency parameters: BF = Beginning Frequency in Hz, LF = Last Frequency
% DF = Frequency increment, NP = Last iteration or number of points
%
BF=480;LF=520;NP=41;
F=linspace(BF,LF,NP);
%
Nc=length(Nom); % Nc = number of components.
rd=180/pi; % To convert radians to degrees.
%
[A,B,D,E,I]=G4(Nom); % Arrays using nominal value of components.
%
% Arrays are constant and real, and they are calculated only once,
% not at each frequency as in admittance matrix analyses.  
% This significantly reduces run times.
%
disp('MCA; please wait ...')
% Nominal phase angle output
% 
for i=1:NP;s=2*pi*F(i)*j;Vn(i)=rd*angle(D*((s*I-A)\B)+E);end;
%
% MCA output
%
Nk=2000; % number of MCA samples.  
% Rule of thumb:  Nk should be a minimum of 1000. More if execution time allows.
%
Vm1=zeros(Nk,NP);Vm2=Vm1; % Create space for output
%
rand('state',sum(100*clock)); %  Random seed for uniform distribtution
randn('state',sum(100*clock)); % Random seed for normal distribution
%
RU=rand(Nk,Nc); %  Random {Nk Nc} array - uniform distribution
RN=randn(Nk,Nc); % Random {Nk Nc} array - normal distribution
%
% Get tolerance constants that do not vary with k samples
%
p=1:Nc;tr1=T(2,:)-T(1,:);tr2=T(1,:)+1;
%
for k=1:Nk
   %
   % Convert random numbers from arrays RU and RN to random component tolerances
   %
   Ru(k,:)=Nom.*(tr1.*RU(k,:)+tr2);
   Rn(k,:)=Nom.*((tr1/6).*(RN(k,:)+3)+tr2);
   %
   [Au,Bu,Du,Eu]=G4(Ru(k,:)); % Arrays randomized by RU
   [An,Bn,Dn,En]=G4(Rn(k,:)); % Arrays randomized by RN
   %
   for i=1:NP
      s=2*pi*F(i)*j;
      Vm1(k,i)=rd*angle(Du*((s*I-Au)\Bu)+Eu); % Uniform phase angle output
      Vm2(k,i)=rd*angle(Dn*((s*I-An)\Bn)+En); % Normal phase angle output
   end % close frequency loop i
end % close MCA loop k
Vmax1=max(Vm1);Vmin1=min(Vm1);  % Get envelopes of extrema.
Vmax2=max(Vm2);Vmin2=min(Vm2);
%
% Plot MCA output.
%
h=plot(F,Vmax1,'r',F,Vmax2,'b',F,Vn,'k--');
set(h,'LineWidth',2);grid on
hold on
h=plot(F,Vmin1,'r',F,Vmin2,'b');
set(h,'LineWidth',2);grid on
hold off
axis ([BF LF 30 180]) 
xlabel('Freq (Hz)');ylabel('Phase Angle (deg)');
title('Allpass MCA - Uniform & Normal Dist') 
YT=linspace(30,180,6);
set(gca,'ytick',YT);
text(496,155,['Nk = ',num2str(Nk)],'FontSize',8);
legend('Uniform','Normal','Nominal');
%
figure(1); % Display plot
ET=toc
