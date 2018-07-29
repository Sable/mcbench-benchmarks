% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% z-Transform properties


% Initial Value Theorem


syms n z
x=(n+1)^2;

X=ztrans(x,z);

x0=limit(X,z,inf)
x1=limit(z*X-z*x0,z,inf)  
x2=limit((z^2)*X-(z^2)*x0-z*x1,z,inf)
