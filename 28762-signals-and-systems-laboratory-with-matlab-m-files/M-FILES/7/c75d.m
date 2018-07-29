% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


% Discrete Fourier Transform  properties


% Parseval's Theorem 

n=0:10;   
x=1./(n+1);
En=sum(abs(x).^2)


N=length(x);
X=dft(x);
Edft=(1/N)*sum(abs(X).^2)
