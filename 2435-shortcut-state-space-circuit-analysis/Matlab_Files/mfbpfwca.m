% Multiple Feeback Bandpass Filter Worst-Case Analysis (WCA) - RSS, EVA, & FMCA
% File: c:\M_files\short_updates\mfbpfwca.m
% updated 11/15/06
clear;clc;
%
% Component values
%
R1=6340;R2=80.6;R3=127000;C1=0.1*1e-6;C2=C1;
Nom=[R1 R2 R3 C1 C2]; % Component vector
Tr=0.02;Tc=0.1; % 2% resistors, 10% capacitors
%
% Tolerance array T; minus in row 1, plus in row 2
% Column order follows component vector X
%
T=[-Tr -Tr -Tr -Tc -Tc;Tr Tr Tr Tc Tc];
Nc=length(Nom); % Nc = number of components
%
Mr=1+(T(2,:)+T(1,:))/2;Nav=Nom.*Mr; % For asymmetric tolerances if any
Tv=(T(2,:)-T(1,:))./(2*Mr); % Tv used for RSS
%
% Linear frequency sweep in Hz
%
BF=400;LF=600;NP=101; % NP = Number of points
F=linspace(BF,LF,NP);
%
Mr=1+(T(2,:)+T(1,:))/2; % For asymmetric tolerances if any
Tv=(T(2,:)-T(1,:))./(2*Mr); % Tv used for RSS only
%
[A,B,D,E,I]=bpf1(Nav); % call nominal arrays
%
% Arrays are constant and real, and they are calculated only once,
% not at each frequency as in admittance matrix analyses.  
% This reduces run times considerably.
%
% Nominal output
%
for i=1:NP
   s=2*pi*F(i)*j;
   Vn(i)=abs(D*((s*I-A)\B)+E); % Magnitude for sensitivities 
end
%
Nf=2^Nc;Vm1=zeros(Nf,NP); % Used in FMCA
k=1:Nf;RB=dec2bin(k-1); % RB is a binary array Nc bits wide and from 0 to Nf-1.
%                         Used in FMCA.  All possible tolerance combinations.
%                         '0' = minus tolerance, '1' = plus tolerance.  
% Normalized sensitivities
%
dpf=0.0001; % derivative perturbation factor
%
% Get normalized sensitivities.  For Q and R perturbation vectors below:
% p = 1, Qx = [1.0001 1 1 1 1]; Bx = [0.9999 1 1 1 1];
% p = 2, Qx = [1 1.0001 1 1 1]; Bx = [1 0.9999 1 1 1]; and so forth up to p = Nc.
%
Q=1+dpf;R=1-dpf;
for i=1:NP
   Qx=ones(1,Nc);Rx=Qx; % reset Qx & Bx perturbation vectors
   s=2*pi*F(i)*j;
   for p=1:Nc  % start sensitivity loop
      if p > 1;Qx(p-1)=1;Rx(p-1)=1;end; % reset previous
      Qx(:,p)=Q;Rx(:,p)=R;
      %
      [A,B,D,E,I]=bpf1(Nom.*Qx); % arrays perturbated forward
      Vr=abs(D*((s*I-A)\B)+E); % output perturbated forward
      %
      [A,B,D,E,I]=bpf1(Nom.*Rx); % arrays perturbated backward
      Vb=abs(D*((s*I-A)\B)+E); % output perturbated backward
      %
      Sens(i,p)=(Vr-Vb)/(2*Vn(i)*dpf); % centered difference approximation.
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
   [A,B,D,E]=bpf1(Nav.*Lo); % EVL arrays
   VL(i)=abs(D*((s*I-A)\B)+E); % EVL output
   %
   [A,B,D,E]=bpf1(Nav.*Hi); % EVH arrays
   VH(i)=abs(D*((s*I-A)\B)+E); % EVH output
%   
% RSS (Root-Sum-Square)
%
   STn=norm(Sens(i,:).*Tv);
   Vrss1(i)=Vn(i)*(1-STn);Vrss2(i)=Vn(i)*(1+STn);
%
% FMCA
%
% Binary array RB contains binary numbers Nc bits wide from 0 to Nf-1.
% Used for all Nf = 2^Nc = 32 possible tolerance combinations.
%
   for k=1:Nf  % start FMCA loop
      for p=1:Nc
         if RB(k,p)=='0'
            Tf(p)=1+T(1,p); % minus tolerance if a logic '0'
         else
            Tf(p)=1+T(2,p); % plus tolerance if a logic '1'
         end
      end % close FMCA tolerance loop
      [A,B,D,E,I]=bpf1(Nom.*Tf);
      Vm1(k,i)=abs(D*((s*I-A)\B)+E); 
   end % close FMCA loop
end % close major i loop
%
Vmax1=max(Vm1);Vmin1=min(Vm1); % Get extrema
%
% Plot sensitivities
%
subplot(2,2,1)
% Number of sensitivities to be plotted = Nc
% Adjust 'g=plot(...' statements accordingly.
% All should be plotted to observe any bipolarity (non-monotonicity).
%
h=plot(F,Sens(:,1),'k',F,Sens(:,2),'r',F,Sens(:,3),'g');
set(h,'LineWidth',2);grid on
hold on
h=plot(F,Sens(:,4),'b',F,Sens(:,5),'m');
set(h,'LineWidth',2);
axis auto
hold off
ylabel('% / %');
title('Sensitivities')
legend('R1','R2','R3','C1','C2',3);
%
subplot(2,2,2) % RSSh=plot(F,Vn,'k--',F,Vrss1,'b',F,Vrss2,'r');
set(h,'LineWidth',2);grid on
axis auto
ylabel('Volts')
title('RSS')
%
% Note that RSS shows "negative volts", and hence is bogus.  
% The positive peak excursions are unbelievably about twice nominal. 
% The culprit here is high sensitivity-tolerance products for which
% RSS is not suitable.
%
% What is "high"?  The sensitivities of C1 and C2 here peak at about 10 %/%.
% With 10% tolerance capacitors, ST = 10(0.1) = 1.
% Neglecting the resistors, for C1 and C2 Vrss = sqrt(1^2 + 1^2) = sqrt(2) = 1.414 
% times nominal ADDED to the nominal.  For example, at F = 492 Hz, Vo = 8.23 Vpk.
% Then 8.23(1 + sqrt(2)) = 19.87 V which is close to what is shown on the RSS plot
% at that frequency.    
% The definition of RSS is based on partial derivatives where delta x approaches
% zero, times the SMALL three sigma tolerance of the component.  (Delta x meaning delta
% component, R, C, or L.)  Ten percent is not considered small when combined with a high
% sensitivity.  A rule of thumb is that any (normalized) sensitivity greater than 2 
% is considered high.  This can be used as a guide when designing analog circuits.
%
subplot(2,2,3) % EVA
h=plot(F,Vn,'k--',F,VH,'r',F,VL,'b');
set(h,'LineWidth',2);grid on
axis auto
xlabel('Freq(Hz)');ylabel('Volts');
title('EVA')
%
% EVA and FMCA below show the true worst-case center frequency excursions, 
% but not the maximum output amplitude in Volts at frequencies between these 
% center frequencies. 
% 
subplot(2,2,4) % FMCA
h=plot(F,Vn,'k--',F,Vmax1,'r',F,Vmin1,'b');
set(h,'LineWidth',2);grid on
axis auto
xlabel('Freq(Hz)');ylabel('Volts');
title('FMCA');
figure(1)
%
% FMCA (Fast Monte Carlo Analysis) is somewhat better in that there are seven more 
% peaks not shown on EVA.  However, the gaps at about 475 and 525 Hz are incorrect 
% and therefore misleading.
%
% Run mfpbmca.m and compare.  The output with normal distribution
% input will approach the TRUE RSS tolerance bands with Nk large (> 1000).
% The output with uniform distribution input will NOT approach the EVA tolerance bands 
% (unless Nk = infinity, which of course will not happen).  Nk equal to 
% 5,000 to 10,000 will suffice.  
% Diminishing returns is at work here, as anything over Nk = 5,000 and certainly
% Nk = 10,000, will not show a significant increase in tolerance bands.
%
% In summary, use Monte Carlo Analysis (MCA) for circuits with 
% bipolar sensitivities indicating non-monotonicity, and for circuits
% with high sensitivity-tolerance (ST) products. The higher the number of samples, 
% the more accurate the tolerance bands will be. 



