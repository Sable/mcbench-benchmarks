% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni




%problem 4 - Fourier Transform of t*exp(-3t)*u(t)


syms t w
x=t*exp(-3*t) *heaviside(t);
X=fourier(x,w);
w=-20:.1:20;
X=subs(X,w);
plot(w,abs(X));
legend('magnitude')
figure
plot(w,angle(X));
legend('angle')
figure
plot(w,real(X))
legend('real')
figure
plot(w,imag(X))
legend('imaginary')

