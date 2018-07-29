% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
%
%   Unit step sequence

%  u[n]
 n1=-3:-1;
 n2=0:5;
 n=[n1 n2];
 u1=zeros(size(n1));
 u2=ones(size(n2));
 u=[u1 u2];
 stem(n,u)

%  second way
 figure
 n=-3:5
 n0=0;
 u=(n>=n0)
 stem(n,u)

 
 %u[n-n0]
 figure
 n1=-3:1;
 n2=2:5;
 n=[n1 n2];
 u1=zeros(size(n1));
 u2=ones(size(n2));
 u2=ones(size(n2));
 u=[u1 u2];
 stem(n,u)

%  second way
 figure
 n=-3:5
 n0=2;
 u=((n-n0)>=0)
 stem(n,u)
