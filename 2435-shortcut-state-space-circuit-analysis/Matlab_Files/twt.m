function [A,B,D,E,I]=twt(X);
% subprogram for Twin T circuit
%
N=3; % N = no. of L's & C's
M=1; % M = no. of indep inputs
U=2; % U = no. of dep nodes in dc equivalent circuit
Y=2; % Y = output node in dc equiv ckt = V3
%
% X = [R1 R3 R5 R7 C2 C4 C6];
%      1  2  3  4  5  6  7   
%
R1=X(1);R3=X(2);R5=X(3);R7=X(4);C2=X(5);C4=X(6);C6=X(7);
% Create array space
A1=zeros(U+N);B2=zeros(U+N,N+M);V=zeros(U+N,N+M);H=zeros(N,M+N);
%
% Build A1 matrix.
%
A1=[1/R5 0 0 -1 -1;
   0 -1/R3  1 0 0;
   0 1/R3+1/R7 0 0 1;
   1 0 0 0 0;
   -1 1 0 0 0];
%
% Fill in B2 array
E2=1;E4=1;E6=1;Ein=1;
%
B2=[0 0 0 0;
   -E2*(1/R1+1/R3) 0 0 Ein/R1;
   E2/R3 0 0 0;
   0 -E4 0 Ein;
   0 0 E6 0];
%
P=diag([C2 C4 C6]);
%
% As stated previously, the following code is
% the same for every circuit.
%  
V=A1\B2;H=V(U+1:U+N,1:N+M);I=eye(N);
AB=P\H;A=AB(1:N,1:N);B=AB(1:N,N+1:N+M);
D=V(Y:Y,1:N);E=V(Y:Y,N+1:N+M);
