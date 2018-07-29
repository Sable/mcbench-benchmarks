% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni



%problem 10- Energy spectral density 
% x(t)=exp(-3t)u(t)

%Fourier Transform of autocorrelation
syms t w r
x=exp(-3*t)*heaviside(t);
x1=x;
x_2=subs(x1,t,t-r);
x2=conj(x_2);
R=int(x1*x2,t,-inf,inf)
A=fourier(R,w);
ezplot(A, [-10 10])
legend('F[R_x(\tau)]')


% energy spectral density

figure
X=fourier(x,w)
B=abs(X)^2;
ezplot(B, [-10 10])
legend('Energy spectral density')

