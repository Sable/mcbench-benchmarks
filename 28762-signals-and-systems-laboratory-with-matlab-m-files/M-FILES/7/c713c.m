% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


% problem 3 -  Polar form and real and imaginary parts of the DFT of cos(n*pi/3)


n=0:8;
x=cos((1/3)*pi*n);
Xk=fft(x);
Xk.'

A=abs(Xk).*exp(j*angle(Xk));
A.'

B=real(Xk)+j*imag(Xk);
B.'
