% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni

%Autocorrelation

%x(t)=exp(-t)u(t-1)

%autocorrelation
syms t r w
x1=exp(-t) *heaviside(t-1);
x_2=subs(x1,t,t-r);
x2=conj(x_2)
R=int(x1*x2,t,-inf,inf)
R=simplify(R)


%energy
R0=limit(R,r,0);
eval(R0)
X=fourier(x1,w);
Integ= int((abs(X))^2,w,-inf,inf);
Ew=(1/(2*pi))*Integ;
eval(Ew)


% maximum value 
ezplot(R,[ -10 10])
legend('R_x(\tau)')


% energy spectral density 
syms t w r
x1=exp(-t)*heaviside(t);
x_2=subs(x1,t,t-r);
x2=conj(x_2);
R=int(x1*x2,t,-inf,inf);
Left=fourier(R,w);
ezplot(Left)
legend('F[R_x(\tau)]')

figure
X=fourier(x1,w);
Right=abs(X)^2;
ezplot(Right)
legend('|X(\Omega)|^2')
