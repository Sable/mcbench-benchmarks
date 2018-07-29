% Tow Thomas Bandpass Filter - Worst-Case Analysis (RSS, EVA, FMCA)
% File: c:\M_files\short_updates\TowThomaswca.m
% updated 11/16/06
clear;clc;
K=1e3;uF=1e-6; % Unit suffixes
% Component values
R1=200*K;R2=10*K;R3=20*K;R4=10*K;R5=20*K;R6=20*K;
C1=0.0159*uF;C2=C1;
%
Nom=[R1 R2 R3 R4 R5 R6 C1 C2]; % Place components in vector X
%
Tr=0.02;Tc=0.1; % 2% resistors, 10% capacitors
%
% Tolerance array T; minus in row 1, plus in row 2
% Column order follows component vector X
%
T=[-Tr -Tr -Tr -Tr -Tr -Tr -Tc -Tc;
   Tr Tr Tr Tr Tr Tr Tc Tc];
%   
% Linear frequency; in Hz
%
BF=700;LF=1300;NP=301; % Number of points
F=linspace(BF,LF,NP);
%
Nc=length(Nom); % Nc = number of components
%
% Nominal output
%
Mr=1+(T(2,:)+T(1,:))/2; % For asymmetric tolerances if any
Nav=Nom.*Mr; % Average value of components; = Nom if symmetric tolerances
Tv=(T(2,:)-T(1,:))./(2*Mr); % Tv used for RSS
%
[A,B,D,E,I]=ttbpf(Nav); % call nominal arrays
%
% Arrays are constant and real, and they are calculated only once,
% not at each frequency as in admittance matrix analyses.  
% This reduces run times considerably.
%
for i=1:NP;s=2*pi*F(i)*j;Vn(i)=abs(D*((s*I-A)\B)+E);end; % Nominal output
%
Nf=2^Nc;Vm1=zeros(Nf,NP); % Used in FMCA
k=1:Nf;RB=dec2bin(k-1); % Used in FMCA
%
% Sensitivities
%
dpf=0.0001; % derivative perturbation factor
Q=1+dpf;R=1-dpf;
for i=1:NP
   Qx=ones(1,Nc);Rx=Qx; % reset Q & R
   s=2*pi*F(i)*j;
   for p=1:Nc  % start sensitivity loop; p = component counter
      Qx(p)=Q;Rx(p)=R;
      if p > 1;Qx(p-1)=1;Rx(p-1)=1;end % reset previous
      %
      [A,B,D,E,I]=ttbpf(Nom.*Qx); % arrays perturbated forward
      Vr=abs(D*inv(s*I-A)*B+E); % output perturbated forward
      %
      [A,B,D,E,I]=ttbpf(Nom.*Rx); % arrays perturbated backward
      Vb=abs(D*inv(s*I-A)*B+E); % output perturbated backward
      %
      Sens(i,p)=(Vr-Vb)/(2*Vn(i)*dpf); % centered difference approximation
 % Ref:  Numerical Methods for Engineers, 3rd ed.
 % S.C. Chapra & R.P. Canale, McGraw-Hill, 1998, p.93
 %
 % EVA (Extreme Value Analysis)
 %
      if Sens(i,p) > 0
         Hi(p)=1+T(2,p);Lo(p)=1+T(1,p); % component tolerance for WC High
      else
         Hi(p)=1+T(1,p);Lo(p)=1+T(2,p); % component tolerance for WC Low
      end
   end % close p sensitivity loop
%
% Get extreme value low (EVL) and extreme value high (EVH)
%
	[A,B,D,E,I]=ttbpf(Nav.*Lo);
   VL(i)=abs(D*((s*I-A)\B)+E);
   %
	[A,B,D,E,I]=ttbpf(Nav.*Hi);
   VH(i)=abs(D*((s*I-A)\B)+E);
%   
% RSS (Root-Sum-Square)
%
   STn=norm(Sens(i,:).*Tv);
   Vrss1(i)=Vn(i)*(1-STn);Vrss2(i)=Vn(i)*(1+STn);
%
% FMCA
%
% Binary array RB contains binary numbers Nc bits wide from 0 to Nf.
% Used for all possible tolerance combinations.
%
   for k=1:Nf  % start FMCA loop
      for p=1:Nc
         if RB(k,p)=='0'
            Tf(p)=1+T(1,p); % low tolerance if a logic '0'
         else
            Tf(p)=1+T(2,p); % high tolerance if a logic '1'
         end
      end % close FMCA tolerance loop
      [A,B,D,E,I]=ttbpf(Nav.*Tf);
      Vm1(k,i)=abs(D*((s*I-A)\B)+E); 
   end % close FMCA loop
end % close major i loop
Vmax1=max(Vm1);Vmin1=min(Vm1);
%
% Plot sensitivities
% Number of sensitivities to be plotted = Nc
% Adjust 'g=plot(...' statements accordingly.
% All should be plotted to observe any bipolarity (non-monotonicity).
h=plot(F,Sens(:,1),'k',F,Sens(:,2),'r',F,Sens(:,3),'g',F,Sens(:,4),'b');
set(h,'LineWidth',2);grid on
axis auto
ylabel('%/%');xlabel('Freq (Hz)');
title('Sensitivities')
hold off
legend('R1','R2','R3','R4',0);
figure
%
h=plot(F,Sens(:,5),'k',F,Sens(:,6),'r',F,Sens(:,7),'g',F,Sens(:,8),'b');
set(h,'LineWidth',2);
axis auto;grid on
ylabel('%/%');xlabel('Freq (Hz)');
title('Sensitivities')
legend('R5','R6','C1','C2',0);
figure
%
% RSS
h=plot(F,Vn,'k--',F,Vrss1,'b',F,Vrss2,'r');
set(h,'LineWidth',2);grid on
axis auto
ylabel('Volts');xlabel('Freq (Hz)');
title('RSS')
legend('Nom','RSS Lo','RSS Hi',0);
figure
%
% EVA
h=plot(F,Vn,'k--',F,VH,'r',F,VL,'b');
set(h,'LineWidth',2);grid on
axis auto
xlabel('Freq(Hz)');ylabel('Volts');
title('EVA')
legend('Nom','EVA Hi','EVA Lo',0);
figure
%
% FMCA
h=plot(F,Vn,'k--',F,Vmax1,'r',F,Vmin1,'b');
set(h,'LineWidth',2);grid on
axis auto
xlabel('Freq(Hz)');ylabel('Volts');
title('FMCA');
legend('Nom','FMCA Hi','FMCA Lo',0);
%
% See comments concerning RSS, EVA, & FMCA at end of mfbpfwca.m

