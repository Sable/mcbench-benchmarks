% Introduction to DS Method - Series LCR Circuit
% File:  dsintro.m
% 12/13/04
clc;clear;
format short g
% Unit suffixes
uF=1e-6;mH=1e-3;KHz=1e3;
%
% Assign component and source values
%
L1=1*mH;C2=0.253303*uF;R3=5;I1=1;E2=1;Ein=1;
%
% Assign circuit parameters.
%
N=2; % Order of circuit; i.e., number of L's and/or C's.
M=1; % Number of independent inputs.
U=2; % Number of unknown nodes in converted circuit.
Y=2; % Output node.
%
% Form A1 & B2
%
%  V1 V2 eL1 iC2  column order of A1
A1=[0 0 0 1;
   0 1 0 0;
   1 -1 0 0;
   1 0 1 0];
%
%  I1 E2 Ein  column order of B2
B2=[I1 0 0;
   I1*R3 0 0;
   0 E2 0;
   0 0 Ein];
%
P=diag([L1 C2]); % Order L1 C2 corresponds to order of I1 and E2 in B2.
%
% As noted previously in the Word file dsintro.doc, if the arrays A1, B2, and P are 
% set up correctly as shown here, the coding from here on never changes from 
% circuit to circuit, and is hence guaranteed to be correct.  
% The remaining code, starting with V=A1\B2, will always be the same, 
% i.e., it is a template or "boilerplate".
%
% Uncomment the following two lines to echo the screen display to a text file qbout.txt
%
%fid=fopen('c:\M_files\qbout.txt','w'); % Use local directory
%diary c:\M_files\qbout.txt; % Use local directory
%
% Solve for superposed dc node voltages, dc voltages across the 1A sources, (replacing
% the L's) and dc currents through the 1V sources (replacing the C's).
%
V=A1\B2
% 
% H is the last N rows extracted from V.
%
H=V(U+1:U+N,1:N+M)
%
% Get AB containing A and B arrays
%
AB=P\H
%
% Extract A and B from AB
%
A=AB(1:N,1:N)
B=AB(1:N,N+1:N+M)
%
% Extract D and E from V
%
D=V(Y:Y,1:N)
E=V(Y:Y,N+1:N+M)
%
% Optional:  Get Eigenvalues (poles of circuit transfer function)
%
L=eig(A)/(2*pi) % complex conjugate poles
fo=abs(L(1)) % magnitude of one pole
%
% Dc analysis
%
X=-A\B
Vdc=D*X+E
%
% AC analysis
%
BF=5*KHz; % BF = Beginning Frequency in Hz
LF=15*KHz; % LF = Last Frequency in Hz
NP=101; % NP = Number of points 
I=eye(N); % Nth order identity matrix
F=linspace(BF,LF,NP); % Vector of frequency points
%
for i=1:Lit
   s=2*pi*F(i)*j; % j = sqrt(-1)
   cv=D*((s*I-A)\B)+E; % complex value of output
   Vo(i)=abs(cv); % Output magnitude in Volts at node Y = 2.
end
%
% plot Vo
%
h=plot(F/KHz,Vo,'k');
grid on;
set(h,'LineWidth',2);
title('Output at node Y=2');
xlabel('Freq (kHz)');ylabel('Volts');
XT=linspace(BF/KHz,LF/KHz,11);
set(gca,'xtick',XT); % force X-axis tick marks
figure(1); 
% If opened above, close the opened file qbout.txt
%diary off
%status=fclose(fid);







