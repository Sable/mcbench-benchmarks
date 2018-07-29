% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
% problem 10 - Energy computation of the signal x[n]=1.01^n ,n=0,1,...,100



n=0:1e2;   
x=1.01.^n;
En=sum(abs(x).^2)

N=length(x);
X=fft(x);
Edft=(1/N)*sum(abs(X).^2)

syms w
X=sum(x.*exp(-j*w*n));
Esd=abs(X)^2
E=1/(2*pi)*int(Esd,w,-pi,pi);
Edtft=eval(E)
