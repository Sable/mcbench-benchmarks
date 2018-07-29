% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%                                         
% Laplace and inverse Laplace Transforms of various functions



% L{exp(-t)}
syms t s w
f=exp(-t);

laplace(f)

laplace(f,s)

laplace(f,w)

syms n
f=exp(-n);
laplace(f,t)

f=exp(-s);
laplace(f)

% L{1}
f=1
laplace(f,s)


% L^-1{1/(1+s)}
syms t s
F=1/(1+s);
ilaplace(F)

% L^-1{1/(s+2)}
syms n
F=1/(s+2)
f= ilaplace(F,n)

syms w
F=1/(w+2);
ilaplace(F,s)

% L^-1{-1}
F=1;
ilaplace(F,t)



%Common mistakes 
f=1
laplace(f)

F=1;
ilaplace(F)


f=exp(-t);
laplace(f,t)

F=1/(s+2)
f=ilaplace(F,s)



