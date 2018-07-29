% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%                                         
% Laplace Transform properties


% Integration in the complex frequency

x=sin(t);

L=laplace(x/t,s);
ezplot(L,[0 100])

figure
syms u
X=laplace(x,u);
R=int(X,u,s,inf);
ezplot(R,[0 100])




