% All Pass Filter Sensitivities, RSS & WCA
% File: c:\M_files\short_updates\allpassrss.m
% Circuit function: G4.m
% updated 11/16/06
% 
clear;clc
K=1e3;u=1e-6;
R1=626.25;R2=22.55*K;R3=25.05*K;R4=225.45*K;
C1=0.1*u;C2=C1;
Nom=[R1 R2 R3 R4 C1 C2]; % vector of nominal component values
BF=450;LF=550;NP=101; % linear freq sweep
F=linspace(BF,LF,NP);
% Form symmetric tolerance array T
Tr=0.01;Tc=0.05;
%
T=[-Tr -Tr -Tr -Tr -Tc -Tc;Tr Tr Tr Tr Tc Tc];
Nc=size(T,2); % Nc = number of components
% For assymetric tolerances if present
Mr=1+(T(2,:)+T(1,:))/2;
Tv=(T(2,:)-T(1,:))./(2*Mr); % Used only in RSS 
Nav=Nom.*Mr; % Shift components to average value if
% tolerances are assymetric.  Mr = all 1's if symmetric.
%
[An,Bn,Dn,En,I]=G4(Nom); % Nominal SS arrays
%
dpf=0.0001; % derivative perturbation factor
rd=180/pi; % convert radians to degrees
%
% Q & R perturbation vectors are sequenced below:
% Reset; Q = [1 1 1 1 1]; R = [1 1 1 1 1]
% p = 1; Q = [1.0001 1 1 1 1];R = [0.9999 1 1 1 1];
% p = 2; Q = [1 1.0001 1 1 1];R = [1 0.9999 1 1 1]; 
% and so forth up to p = Nc.
%
Q=1+dpf;R=1-dpf;
%
for i=1:NP % Begin frequency sweep
   Qx=ones(1,Nc);Rx=ones(1,Nc); % Reset perturbation vectors
   s=2*pi*F(i)*j;
   Vo(i)=rd*angle(Dn*((s*I-An)\Bn)+En); % Nominal output
   for p=1:Nc % Begin component loop
      Qx(p)=Q;Rx(p)=R;
      if p > 1;Qx(p-1)=1;Rx(p-1)=1;end; % Reset previous
% Perturbate components forward with Q = 1+dpf   
      [A,B,D,E]=G4(Nom.*Qx);
      Vr=rd*angle(D*((s*I-A)\B)+E);
% Perturbate components backward with R = 1-dpf
      [A,B,D,E]=G4(Nom.*Rx);
      Vb=rd*angle(D*((s*I-A)\B)+E);
      %
      Sen(i,p)=(Vr-Vb)/(2*Vo(i)*dpf); % Centered difference approximation
      %
      % For EVA
      %
      if Sen(i,p) > 0
         Lo(p)=1+T(1,p);Hi(p)=1+T(2,p);
      else
         Lo(p)=1+T(2,p);Hi(p)=1+T(1,p);
      end
   end % end component loop
   %
   % Get EVA VL and EVA VH
   %
   [A,B,D,E]=G4(Nom.*Lo);
   VL(i)=rd*angle(D*((s*I-A)\B)+E);
   [A,B,D,E]=G4(Nom.*Hi);
   VH(i)=rd*angle(D*((s*I-A)\B)+E);
   %
   % Get RSS using norm function
   %
   STn=norm(Sen(i,:).*Tv);
   Vrss1(i)=Vo(i)*(1-STn);Vrss2(i)=Vo(i)*(1+STn);
end % close frequency sweep loop i
%
subplot(2,2,1)
h=plot(F,Sen(:,5),'r',F,Sen(:,6),'b');
set(h,'LineWidth',2);
grid on
axis auto
set(gca,'FontSize',8)
%xlabel('Freq (Hz)');
ylabel('%/%')
title('C Sensitivities')
legend('C1','C2',0);
%
subplot(2,2,2)
h=plot(F,Sen(:,1),'k',F,Sen(:,2),'r',F,Sen(:,3),'b',F,Sen(:,4),'g');
set(h,'LineWidth',2);
grid on
axis auto
set(gca,'FontSize',8)
%xlabel('Freq (Hz)');
ylabel('%/%')
title('R Sensitivities')
legend('R1','R2','R3','R4',0);
%
subplot(2,2,4)
m=plot(F,VL,'b',F,VH,'r',F,Vo,'k--');
set(m,'LineWidth',2)
grid on
axis auto
set(gca,'FontSize',8)
%axis([BF LF 30 180])
%YT=linspace(30,180,6);
%set(gca,'ytick',YT);
xlabel('Freq (Hz)');
ylabel('Degrees')
title('EVA')
legend('EVLo','EVHi','Nom',0)
%
subplot(2,2,3)
m=plot(F,Vrss1,'b',F,Vrss2,'r',F,Vo,'k--');
set(m,'LineWidth',2)
grid on
axis auto
set(gca,'FontSize',8)
%axis([BF LF 30 180])
%YT=linspace(30,180,6);
%set(gca,'ytick',YT);
xlabel('Freq (Hz)');
ylabel('Degrees')
title('RSS')
legend('RSSLo','RSSHi','Nom',0)
%
figure(1);


