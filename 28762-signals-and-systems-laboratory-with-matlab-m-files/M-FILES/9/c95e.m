% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%                                         
% Laplace Transform properties


% Differentiation in the s-domain

x=exp(t);

f=((-t)^5)*x;
L=laplace(f,s)

X=laplace(x,s);
R=diff(X,5)


