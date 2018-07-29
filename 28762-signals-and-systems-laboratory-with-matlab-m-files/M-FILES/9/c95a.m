% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%                                         
% Laplace Transform properties


%linearity 

syms t s
x1=exp(-t); 
x2=cos(t);
a1=3;  
a2=4;

Le=a1*x1+a2*x2;
Left=laplace(Le,s)

X1=laplace(x1);
X2=laplace(x2);
Right=a1*X1+a2*X2
