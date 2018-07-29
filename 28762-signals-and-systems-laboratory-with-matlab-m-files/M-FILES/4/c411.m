% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 
% step response

 a=[1 -1];
 b=[.2 .1];
 n=0:100;
 u=ones(size(n));
 s=filter(b,a,u);
 stem(0:100,s);
title('Step response of the system')
