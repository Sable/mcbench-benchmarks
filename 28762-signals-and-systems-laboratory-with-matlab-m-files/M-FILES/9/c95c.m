% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%                                         
% Laplace Transform properties


% Complex frequency shifting


x=t^3;
s0=2;

f=x*exp(s0*t);
L=laplace(f,s)


X=laplace(x,s);
R=subs(X,s,s-2)
