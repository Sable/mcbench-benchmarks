% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%                                         
% Laplace Transform properties


% Integration in the time-domain

syms r
x=exp(3*r);
le=int(x,r,-inf,t);
L=laplace(le,s)


X=laplace(x,s);
xr=int(x,r,-inf,0)
R=X/s + xr/s
simplify(R)
