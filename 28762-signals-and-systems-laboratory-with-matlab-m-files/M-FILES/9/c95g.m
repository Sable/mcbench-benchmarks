% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%                                         
% Laplace Transform properties


% Differentiation in the time-domain

x=cos(t);

L=diff(x,t) ;
laplace(L,s) 

X=laplace(x,s);
x0=1;
R=s*X-x0;
simplify(R)
