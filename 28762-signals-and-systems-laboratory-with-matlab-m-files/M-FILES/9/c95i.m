% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%                                         
% Laplace Transform properties


% Initial and Final Value Theorems


%Initial Value Theorem
x=sin(t);
X=laplace(x,s);
limit(s*X,s,inf)


%Final Value Theorem
x=1-exp(-t);
limit(x,t,inf)

X=laplace(x,s);
limit(s*X,s,0)
