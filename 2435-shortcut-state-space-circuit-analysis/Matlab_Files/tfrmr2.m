function [A,B,D,E,I]=tfrmr2(X)
% Subprogram for pulse transformer
% 02/15/07
% X = [R1 R2 R3 R4 R5 R6 R7 C1 C2 C3 L1 L2 L3]
R1=X(1);R2=X(2);R3=X(3);R4=X(4);R5=X(5);R6=X(6);R7=X(7);
C1=X(8);C2=X(9);C3=X(10);
L1=X(11);L2=X(12);L3=X(13);
N=6;U=5;M=1;Y=4; % Y = 4 is the 4th column of A1 which is V6 
% create space for and zero A1 & B2 matrices
A1=zeros(U+N);B2=zeros(U+N,N+M);
%
% Column alignment for A1 array:
%
% V2 V3 V4 V6 V7 iC1 iC2 iC3 eL1 eL2 eL3
% 1  2  3  4  5  6   7   8   9   10  11
%
A1(1,6)=1;A1(1,7)=1; % LH side of node E1 equation
A1(2,1)=1/R2; % LH side of node V1 equation, etc.
A1(3,2)=1/R3; % Node V2
A1(4,2)=1/R4;A1(4,3)=-1/R4; % Node V3
A1(5,7)=1;A1(5,8)=-1; % Node E3
A1(6,4)=1/R6;A1(6,7)=1; % Node V4
A1(7,2)=1/R7;A1(7,5)=-1/R7; % Node V5
A1(8,4)=1; % For LH side of V4=E2+E3
A1(9,1)=1;A1(9,2)=-1;A1(9,9)=-1; % V1-V2-eL1=0
A1(10,5)=-1;A1(10,10)=1; % eL2=V5 or eL2-V5=0
A1(11,3)=1;A1(11,11)=-1; % V3-E3-eL3=0 or V3-eL3=E3
%
E1=1;E2=1;E3=1;I1=1;I2=1;I3=1;Ein=1; % Used as column identifiers.
%
% Column alignment for B2 array
% E1 E2 E3 I1 I2 I3 Ein
% 1  2  3  4  5  6  7
B2(1,1)=-E1/R1;B2(1,4)=-I1;B2(1,7)=Ein/R1; % RH side of node E1=V1 equation
B2(2,1)=E1/R2;B2(2,4)=-I1; % RH side of node V2 equation
B2(3,4)=I1;B2(3,5)=-I2;B2(3,6)=-I3; % RH side of node V3 equation, etc.
B2(4,6)=I3; % RH side node V3 
B2(5,3)=E3/R5;B2(5,6)=-I3; % RH side node E3
B2(6,1)=E1/R6; % RH side node V4
B2(7,5)=I2; % RH side node V5
B2(8,2)=E2;B2(8,3)=E3;
B2(11,3)=E3;
%
P=diag([C1 C2 C3 L1 L2 L3]); % same order as A1 columns 6 thru 11
%
% Template statements:
%
V=A1\B2;H=V(U+1:U+N,1:N+M);I=eye(N);
AB=P\H;A=AB(1:N,1:N);B=AB(1:N,N+1:N+M);
D=V(Y:Y,1:N);E=V(Y:Y,N+1:N+M); 
