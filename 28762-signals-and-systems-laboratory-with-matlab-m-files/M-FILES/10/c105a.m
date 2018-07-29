% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% z-Transform properties


%linearity 

syms n z

x1=n^2;
x2=2^n;
a1=3;
a2=4;

Le=a1*x1+a2*x2;
Left=ztrans(Le,z)

X1=ztrans(x1);
X2=ztrans(x2);
Right=a1*X1+a2*X2
