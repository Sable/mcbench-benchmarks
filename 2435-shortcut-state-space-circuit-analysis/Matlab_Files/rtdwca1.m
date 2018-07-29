% RTD Circuit WCA 
% File:  c:\M_files\finalsub2\rtdwca1.m
% 10/07/02 - Revised to correct fatal error.  'G1' should be 'rtd'
%
clc;clear;format short g;
%
% All resistor values in Kohms
%
R1=4.53;R2=34.8;R3=132;R4=9.09;R5=9.09;R6=4.53;
R7=27.4;R8=20;R9=20;RT=1.915;
E1=5; % Reference voltage
%
X=[R1 R2 R3 R4 R5 R6 R7 R8 R9 RT E1]; % Component vector X
%
Tinit=0.001;Tlife=0.002;
ppm=1e-6;TC1=50*ppm;TC2=25*ppm; % tempco's
Thi=Tinit+Tlife+35*TC1;Tlo=-Tinit-Tlife-80*TC1; % resistor tolerances
Trhi=8.1*1e-4;Trlo=-Trhi; % RTD tolerance
Trefhi=0.02+35*TC2;Treflo=-0.02-80*TC2; % Vref (E1) tolerances
%
% Create tolerance array T
%
T=zeros(2,11);
p=1:9;T(1,p)=Tlo;T(2,p)=Thi; % resistor tolerances (asymmetric)
T(1,10)=Trlo;T(2,10)=Trhi; % RT tolerance (symmetric)
T(1,11)=Treflo;T(2,11)=Trefhi;
%
Nc=length(X); % Number of components
%
Vo=rtd(X); % Vo = nominal dc output
%
Mr=1+(T(2,:)+T(1,:))/2; % Mr is all 1's for symmetric tolerances.
Ts=(T(2,:)-T(1,:))./(2*Mr);
Ry=X.*Mr;Va=rtd(Ry); % Va = average dc output
%
% With symmetric tolerances, Va = Vo.
%
% Normalized sensitivities
%
dpf=0.0001; % Derivative perturbation factor
Q=ones(1,Nc);R=Q; % initialize perturbation arrays
%
% When p = 1, Q = [1.0001 1 1 1 ...], R = [0.9999 1 1 1 ...]
% When p = 2, Q = [1 1.0001 1 1 ...], R = [1 0.9999 1 1 ...], and so forth
%
for p=1:Nc
   if p > 1
      Q(p-1)=1;Q(p)=1+dpf;R(p-1)=1;R(p)=1-dpf;
   else
      Q(p)=1+dpf;R(p)=1-dpf; % p = 1
   end
   Vr=rtd(Ry.*Q);Vb=rtd(Ry.*R);Sens(p)=(Vr-Vb)/(2*Va*dpf);
   if Sens(p)>0
      M(1,p)=1+T(1,p);M(2,p)=1+T(2,p);
   else
      M(1,p)=1+T(2,p);M(2,p)=1+T(1,p);
   end
end
%
% EVA
%
for c=1:2;Veva(c)=rtd(X.*M(c,:));end % EVA about nominal, not average component value
%
% RSS
%
STn=norm(Sens.*Ts);Vrss(1)=Va*(1-STn);Vrss(2)=Va*(1+STn);
%
% FMCA
%
Nf=2^Nc;
k=1:Nf;RB=dec2bin(k-1); % RB is a binary array Nc bits wide from 0 to Nf-1.
%
% Represents all 2^Nc possible tolerance combinations
% Constraint:  If Nc is large, Nf = 2^Nc will be very large.  E.g., 2^15 = 32,768.  
%
for k=1:Nf
   for p=1:Nc
      if RB(k,p)=='0'
         Tf(k,p)=1+T(1,p); % minus tolerance if logic '0'
      else
         Tf(k,p)=1+T(2,p); % plus tolerance if logic '1'
      end
   end
   Vf(k)=rtd(X.*Tf(k,:));   
end
Vfmca(1)=min(Vf);Vfmca(2)=max(Vf);
%   
Von=[Vo Va];V1=[Vrss;Von;Veva;Vfmca];V1=V1';
%
% Display sensitivities with components X
%
disp('       Sens      Components');
sen=Sens(1,:);
SenX=[sen;X]'
%Sens=Sens'
disp('Output format for V1:');
disp(' ');
disp('     RSS Lo    Nom      EVA Lo     FMCA Lo');
disp('     RSS Hi    Avg      EVA Hi     FMCA Hi');
format short;
V1
disp('in Volts DC')
%
% Note:  In this circuit, EVA = FMCA.  This is not always true for every dc circuit.
% Hence FMCA is more accurate for all dc circuits and should be used as the true
% extreme value (or "worst-case").  The author has two example dc circuits where FMCA
% is greater than EVA.  Email:  bobboyd@ieee.org
% Also note that Nom (Vo) does not equal Avg (Va).  This indicates asymmetric tolerances
% are being used.
