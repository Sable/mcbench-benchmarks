% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni



%problem 2 - Fourier Transform of sinc(t)

syms t w
x=sin(pi*t)/(pi*t);
X=fourier(x,w);
ezplot(X, [-10 10])
legend('X(\Omega)');
xlabel('\Omega');
