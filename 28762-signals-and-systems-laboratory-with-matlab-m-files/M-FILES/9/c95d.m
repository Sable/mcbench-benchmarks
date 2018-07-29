% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%                                         
% Laplace Transform properties


% Time Scaling


syms b
le=exp(-b*2*t);
L=laplace(le,s)

x=exp(-2*t);
X=laplace(x,s);

R=(1/b)*subs(X,s,s/b);
simplify(R)

