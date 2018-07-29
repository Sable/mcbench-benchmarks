% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni



%problem 8- energy of cos(t)

syms t w
x=cos(t);
Et=int((abs(x))^2,t,-inf,inf)


X=fourier(x,w);
Ew=(1/(2*pi))*int((abs(X))^2,w,-inf,inf)
