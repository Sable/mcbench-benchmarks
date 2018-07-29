% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni

%Parseval's Theorem  

%x(t)=exp(-t^2)

syms t w
x=exp(-t^2);
Et=int((abs(x))^2,t,-inf,inf) ; 
eval(Et)
X=fourier(x,w);
Ew=(1/(2*pi))*int((abs(X))^2,w,-inf,inf);
eval(Ew)


%x(t)=exp(-t)u(t)
x=exp(-t) *heaviside(t);
Et=int((abs(x))^2,t,-inf,inf)
X=fourier(x,w);
Integ= int((abs(X))^2,w,-inf,inf);
Ew=(1/(2*pi))*Integ;
eval(Ew)
