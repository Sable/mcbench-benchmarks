% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


%Fourier Transfrom properties

%	Linearity


%x1=exp(-3*t)u(t), x2=t*exp(-t)u(t)
syms t w
a1=3 ;  a2 =4 ; 
x1=exp(-3*t) *heaviside(t);
x2=t*exp(-t) *heaviside(t);
Le=a1*x1+a2*x2;
Left=fourier(Le)

X1= fourier (x1);
X2= fourier (x2);
Right=a1*X1+a2*X2

simplify(Left -Right)
