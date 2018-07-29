% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni

%Fourier Transfrom properties

%	Differentiation in time and frequency

%x(t)=exp(-t)u(t)+exp(t)u(-t)
syms t r w
x=exp(r)*heaviside(-r)+exp(-r)*heaviside(r);

%F{int(x(r)}
integ=int(x,r,-inf,t);
Left=fourier(integ,w)


% X(w)/(jw)+ð×(0)ä(w)
X=fourier(x,w);
X0=subs(X,w,0);
Right=(1/(j*w))*X+pi*X0*dirac(w)