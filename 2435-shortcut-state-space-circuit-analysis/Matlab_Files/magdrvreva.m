% Magnet Driver Circuit and WCA - compare with Spice 
% File:  magdrvreva.m
% 9/20/02 2/16/07
clc;clear
K=1e3;pF=1e-12;uF=1e-6;
%
R1=4.99*K;R2=1*K;R3=10*K;C1=0.1*uF;C2=400*pF;
%
X=[R1 R2 R3 C1 C2]; % Put components in vector form
Nc=length(X); % Nc = number of components
% 
% Tolerance array T; R1 = 2%, R2 & R3 = 6%, C1 = 10%, C2 = 50%
%
% Symmetric tolerances used here.
Tr1=0.02;Tr2=0.06; % Resistor tolerances in decimal percent
Tc1=0.1;Tc2=0.5; % Capacitor tolerances in decimal percent
%
% Form tolerance array T: (minus first row, plus second row)
%
T=[-Tr1 -Tr2 -Tr2 -Tc1 -Tc2;Tr1 Tr2 Tr2 Tc1 Tc2];
%
% If tolerances are asymmetric, then the following is required
Mr=1+(T(2,:)+T(1,:))/2; % Mr all 1's if tolerances are symmetric.
Ts=(T(2,:)-T(1,:))./(2*Mr); % Note the "./" in Ts
%
dpf=0.0001; % derivative perturbation factor
%
% Log frequency sweep; BF = beginning log freq; ND = number of decades
% PD = points per decade; NP = total number of frequency points
%
BF=1;ND=3;PD=50;NP=ND*PD+1;L=linspace(BF,BF+ND,NP);
%
[An,Bn,Dn,En,I]=mdds(X); % nominal arrays
%
% Get normalized sensitivities.  For Q and R perturbation vectors below:
% Reset: Q = [1 1 1 1 1];      R = [1 1 1 1 1];
% p = 1, Q = [1.0001 1 1 1 1]; R = [0.9999 1 1 1 1];
% p = 2, Q = [1 1.0001 1 1 1]; R = [1 0.9999 1 1 1]; and so forth up to p = Nc.
%
for i=1:NP
   Q=ones(1,Nc);R=ones(1,Nc); % reset perturbation vectors
   F=10^L(i);s=2*pi*F*j;
   Vn(i)=abs(Dn*((s*I-An)\Bn)+En);Vo(i)=20*log10(Vn(i)); % nominal output
   % Vn used for sensitivity calculation below; Vdb used for output
   for p=1:Nc
      if p > 1
         Q(p-1)=1;R(p-1)=1;Q(p)=1+dpf;R(p)=1-dpf;
      else
         Q(p)=1+dpf;R(p)=1-dpf;
      end
%
      Cf=X.*Q;Cb=X.*R; % vector multiply X by Q and R so that one component at a 
%    time is purturbated by 1+dpf and 1-dpf.
%
      [A,B,D,E,I]=mdds(Cf); % arrays perturbated forward 
      Vr=abs(D*((s*I-A)\B)+E); % forward output
%
      [A,B,D,E,I]=mdds(Cb); % arrays perturbated backward
      Vb=abs(D*((s*I-A)\B)+E); % backward output
%
      Sen(i,p)=(Vr-Vb)/(2*Vn(i)*dpf); % Centered difference approximation is more accurate.
% Ref:  Numerical Methods for Engineers, 3rd ed.
% S.C. Chapra & R.P. Canale, McGraw-Hill, 1998, p.93
%
% Get Extreme Value Analysis (EVA) multipliers based on sensitivity polarity:
      if Sen(i,p) > 0
         Lo(p)=1+T(1,p);Hi(p)=1+T(2,p);
      else
         Lo(p)=1+T(2,p);Hi(p)=1+T(1,p);
      end
   end % end p loop
   %
   % Get Extreme Value Low VL and Extreme Value High VH
   %
   [A,B,D,E,I]=mdds(X.*Lo);Vlo=abs(D*((s*I-A)\B)+E);VL(i)=20*log10(Vlo);
   [A,B,D,E,I]=mdds(X.*Hi);Vhi=abs(D*((s*I-A)\B)+E);VH(i)=20*log10(Vhi);
   %
   % Get RSS using norm function
   %
   STn=norm(Sen(i,:).*Ts);
   Vrs1=Vn(i)*(1-STn);Vrs2=Vn(i)*(1+STn);
   Vrss1(i)=20*log10(Vrs1);Vrss2(i)=20*log10(Vrs2);
end
%
% Plot Sensitivities
%
subplot(2,2,1)
h=plot(L,Sen(:,1),'k',L,Sen(:,2),'g',L,Sen(:,3),'b');
set(h,'LineWidth',2);
grid on
ylabel('%/%');
title('Sensitivities of R1 R2 R3');
legend('R1','R2','R3',0);
%
subplot(2,2,2)
h=plot(L,Sen(:,4),'k',L,Sen(:,5),'g');
set(h,'LineWidth',2);
grid on
ylabel('%/%');
title('Sensitivities of C1 C2');
legend('C1','C2',0);
%
% Plot outputs
%
subplot(2,2,3)
h=plot(L,Vrss1,'b',L,Vo,'k--',L,Vrss2,'r');
set(h,'LineWidth',2);
grid on
xlabel('Log Freq(Hz)');
ylabel('dBV');
title('Nominal & RSS Output');
%
subplot(2,2,4)
h=plot(L,VL,'b',L,VH,'r',L,Vo,'k--');
set(h,'LineWidth',2);
grid on
xlabel('Log Freq(Hz)');
ylabel('dBV');
title('Nominal & EVA Output');
figure(1);


   

