% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% z-Transform properties


% Final Value Theorem


syms n z
x=0.8^n;

limit(x,n,inf)

X=ztrans(x,z);

limit( (z-1)*X,z,1)

limit( (1-z^-1)*X,z,1)
