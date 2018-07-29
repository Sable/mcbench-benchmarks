% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni

%Fourier Transfrom properties

%	Conjugation

%x(t)=exp(-t)u(t)

%F{conj{x(-t)}}
x=exp(-2*t)*heaviside(t);
x_=subs(x,t,-t)
Left=fourier(x_,w)

%conj{X(w)}
X=fourier(x,w);
Right=conj(X)
