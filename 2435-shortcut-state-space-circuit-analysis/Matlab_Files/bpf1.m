function [A,B,D,E,I]=bpf1(X)
% Multiple Feedback Bandpass Filter
% Note that complex frequency variable s is not used here.
% These arrays are real, not complex.
% 
R1=X(1);R2=X(2);R3=X(3);C1=X(4);C2=X(5);
%
N=2;M=1;U=1;Y=1;
%
A1=[0 1 1;
   1/R3 1 0;
   1 0 0];
%
B2=[-(1/R1+1/R2) 0 1/R1;
   0 0 0;
   1 -1 0];
%   
P=diag([C1 C2]);
%
% The following statements never change from circuit to circuit.
%
V=A1\B2;H=V(U+1:U+N,1:N+M);I=eye(N);
AB=P\H;A=AB(1:N,1:N);B=AB(1:N,N+1:N+M);
D=V(Y:Y,1:N);E=V(Y:Y,N+1:N+M);

