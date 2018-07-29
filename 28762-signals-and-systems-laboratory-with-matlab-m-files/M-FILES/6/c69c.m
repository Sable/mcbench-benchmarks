% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni




%problem 3 - Inverse Fourier Transform of sin(w)/w

syms t w
X=sin(w)/w;
x=ifourier(X,t)
ezplot(x, [-3 3])
