function [A,B,D,E,I]=tow(X)
% gets A, B, D, & E arrays for Tow Thomas BPF
N=2;U=3;M=1;Y=[1 2 3]; % Three outputs, V2, V4 & V6
% First three columns of A1
A1=zeros(U+N);B2=zeros(U+N,N+M);
% R1 R2 R3 R4 R5 R6 C1 C2
% 1  2  3  4  5  6  7  8  component locations in X.
%
% V2 V4 V6 iC1 iC2  column labels for A1
% 1  2  3  4	5
%
% A1
%
A1(1,1)=1/X(6);A1(1,2)=1/X(1);A1(1,4)=-1; % From 1st equation
A1(2,1)=1;A1(2,3)=X(5)/X(4); % 2nd equation
A1(3,2)=1/X(2);A1(3,5)=-1;
A1(4,2)=1; % V4 = -E1
A1(5,3)=1; % V6 = -E2
%
% B2
%
%1   2    3   Column labels for B2
B2(2,3)=-X(5)/X(3);
B2(4,1)=-1;
B2(5,2)=-1;
%
P=diag([X(7) X(8)]);
%
V=A1\B2;H=V(U+1:U+N,1:N+M);I=eye(N);
AB=P\H;A=AB(1:N,1:N);B=AB(1:N,N+1:N+M);
% Here we depart from template form slightly to show how D and E are 
%   created for multiple outputs.
D=V(Y(1):Y(3),1:N);
E=V(Y(1):Y(3),N+1:N+M);

