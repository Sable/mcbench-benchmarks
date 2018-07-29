% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%                                         
% Laplace Transform properties


% Time shifting 

syms t s
t0=2;

Le=cos(t-t0)*heaviside(t-t0);
Left= laplace(Le)

X=laplace(cos(t),s);
Right=exp(-s*t0)*X
