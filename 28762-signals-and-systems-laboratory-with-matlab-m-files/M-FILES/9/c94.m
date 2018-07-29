% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%                                         
% Laplace Transform pairs

syms s t a w

laplace(dirac(t),s)

laplace(heaviside(t),s)

n=4
x=diff(dirac(t),n);
X= laplace(x,s)

x=exp(-a*t) *heaviside(t);
laplace(x,s)

ilaplace(1/(s-a),t)

laplace(exp(j*w*t),s)

X= s/(s^2+w^2);
x=ilaplace(X)

x=sin(w*t);
X=laplace(x)

x=exp(-a*t) *cos(w*t);
laplace(x,s)

X=w/((s+a)^2+w^2);
x= ilaplace(X,t)

x=(t^5)*heaviside(t);
laplace(x,t,s)

X=factorial(10) /(s+a)^11;
ilaplace(X,t)

x=t*cos(w*t);
laplace(x,t,s)

X=1/(s+a)^6;
x= ilaplace(X,t)

