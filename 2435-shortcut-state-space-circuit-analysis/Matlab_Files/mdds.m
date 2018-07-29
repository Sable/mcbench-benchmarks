function [A,B,D,E,I]=mdds(X)
% gets A, B, D, E & I arrays for magnet driver
N=2;U=3;M=1;Y=1;
A1=zeros(U+N);B2=zeros(U+N,N+M);
%
% X = [R1 R2 R3 C1 C2]
%
R1=X(1);R2=X(2);R3=X(3);C1=X(4);C2=X(5);
%
% V1 V2 V3 iC1 iC2  column labels for A1
% 1  2  3  4	5
%
A1(1,1)=-1/R1;A1(1,4)=-1;A1(1,5)=-1; % From 1st equation
A1(2,1)=1/R2;A1(2,2)=-1/R2;A1(2,4)=-1; % 2nd equation
A1(3,3)=1;A1(3,4)=-R3;A1(3,5)=-R3; % V3 - iC1*R3 - iC2*R3 = 0
A1(4,2)=1;A1(4,3)=-1; % V2 - V3 = E1
A1(5,1)=1;A1(5,3)=-1; % V1 - V3 = E2
%
E1=1;E2=1;Ein=1;
% E1  E2   Ein  Column labels for B2
%  1   2    3
B2(4,1)=E1;
B2(5,2)=E2;
B2(1,3)=-Ein/R1;
%
P=diag([C1 C2]);
%
% Template statements (same for every circuit):
V=A1\B2;H=V(U+1:U+N,1:N+M);I=eye(N);
AB=P\H;A=AB(1:N,1:N);B=AB(1:N,N+1:N+M);
D=V(Y:Y,1:N);E=V(Y:Y,N+1:N+M);

