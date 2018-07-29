function [A,B,D,E,I] = G4(X)
% All-pass circuit function using DS method
%
N=2;M=1;U=3;Y=3; % Y = Output node, i.e., 3rd unknown node = V4
% For example unknown nodes could be:  V1 V7 V9, then for Y=3 output node is V9.
%
% The following adds to execution time, but is included for clarity.
%
R1=X(1);R2=X(2);R3=X(3);R4=X(4);C1=X(5);C2=X(6);
%
% V1 V2 V4 iC1 iC2
%    1   2 3 4 5   Column labels for A1
A1=[1/R1 0 0 1 1;
   0 -1/R2 1/R2 1 0;
   0 1/R3+1/R4 0 0 0;
   1 -1 0 0 0;
   1 0 -1 0 0];
%
% E1 E2 Ein
%   1 2  3   Column labels for B2
B2=[0 0 1/R1;
   0 0 0;
   0 0 1/R3;
   1 0 0;
   0 1 0];
%
P=diag([C1 C2]);
%
% Remaining code below never has to be changed.
%
V=A1\B2;H=V(U+1:U+N,1:N+M);I=eye(N);
AB=P\H;A=AB(1:N,1:N);B=AB(1:N,N+1:N+M);
D=V(Y:Y,1:N);E=V(Y:Y,N+1:N+M);
