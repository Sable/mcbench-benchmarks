% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


% Discrete Fourier Transform  properties


% linearity


x1= [1 2 3 4 5];
x2= [1 3 5 2 1];
a=3;
b=4;
Left=dft(a*x1+b*x2)

X1=dft(x1);
X2=dft(x2);
Right=a*X1+b*X2
