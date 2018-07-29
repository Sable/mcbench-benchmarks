function [A,B,D,E,I]=ttbpf(X)
% gets A,B,D,E & I arrays for Tow Thomas BPF WCA
% Same as tow.m except for output Y
N=2;U=3;M=1;Y=2; % Y = 2 means V4
A1=zeros(U+N);B2=zeros(U+N,N+M);
% R1 R2 R3 R4 R5 R6 C1 C2
% 1  2  3  4  5  6  7  8  component locations in X.
%
% V2 V4 V6 iC1 iC2  column labels for A1
% 1  2  3  4	5
%
% A1
%
A1=[1/X(6) 1/X(1) 0 -1 0;
   1 0 X(5)/X(4) 0 0;
   0 1/X(2) 0 0 -1;
   0 1 0 0 0;
   0 0 1 0 0];
%
% B2
%
%E1 E2 Ein   Column labels for B2
B2=[0 0 0;
   0 0 -X(5)/X(3);
   0 0 0;
   -1 0 0;
   0 -1 0];
%
P=diag([X(7) X(8)]);
%
% The following code never has to be changed.
%
V=A1\B2;H=V(U+1:U+N,1:N+M);I=eye(N);
AB=P\H;A=AB(1:N,1:N);B=AB(1:N,N+1:N+M);
D=V(Y:Y,1:N);E=V(Y:Y,N+1:N+M);


