% Tolerance analysis of RTD circuit
% File rtdrss2.m
% Circuit function:  G2a.m
% updated version 11/15/06
clear;clc
%
R1=4.53;R2=34.8;R3=132;R4=9.09;R5=9.09;R6=4.53;R7=27.4;
RT=1.915;E1=5;R8=20;R9=20; % in KOhms
%
Nom=[R1 R2 R3 R4 R5 R6 R7 R8 R9 RT E1];
Vo=G2a(Nom);
%
Nc=length(Nom);dpf=0.0001;
%
Qx=ones(1,Nc);Bx=ones(1,Nc); % set perturbation vectors Q & R
Q=1+dpf;B=1-dpf;
%
Tinit=0.001;Tlife=0.002;ppm=1e-6;TC1=50*ppm;TC2=25*ppm;
% TC1 & TC2 are tempco's
Thi=Tinit+Tlife+35*TC1;Tlo=-Tinit-Tlife-80*TC1;
Trhi=8.1e-4;Trlo=-Trhi;Treflo=-0.02-80*TC2;Trefhi=0.02+35*TC2;
T=[ Tlo Tlo Tlo Tlo Tlo Tlo Tlo Tlo Tlo Trlo Treflo;
   Thi Thi Thi Thi Thi Thi Thi Thi Thi Trhi Trefhi];
% For assymetric tolerances
Mr=1+(T(2,:)+T(1,:))/2; % Mr all 1's for symmetric tolerances
Tv=(T(2,:)-T(1,:))./(2*Mr);
Va=G2a(Nom.*Mr);
%
for p=1:Nc
   Qx(p)=Q;Bx(p)=B;
   if p > 1;Qx(p-1)=1;Bx(p-1)=1;end; % Reset previous
   Vr=G2a(Nom.*Qx);Vb=G2a(Nom.*Bx);
%
% Calculate normalized sensitivities
%
   Sen(p)=(Vr-Vb)/(2*Vo*dpf);
%
% Step 9  Get Extreme Value Analysis (EVA) multipliers
%
   if Sen(p) > 0
      Lo(p)=1+T(1,p);Hi(p)=1+T(2,p);
   else
      Lo(p)=1+T(2,p);Hi(p)=1+T(1,p);
   end
end
%
% Step 10  Calculate EVA output values
%
VL=G2a(Nom.*Lo); % EVA Low or EVL
VH=G2a(Nom.*Hi); % EVA High or EVH
%
% Calculate RSS values using norm function
%
STn=norm(Sen.*Tv);
Vrss1=Va*(1-STn);Vrss2=Va*(1+STn);
%
V1=[Vrss1 Vo VL;Vrss2 Va VH];
%
% Display output
%
format short
disp('RTD Circuit');
disp(' ');
disp('     RSS      NOM       EVA');
disp(V1);
