% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
% this function  computes the inverse Discrete Fourier 
% Transform x of a sequence X



function x=idft(Xk)
N=length(Xk);
for n=0:N-1
 for k=0:N-1
  xn(k+1)=Xk(k+1)*exp(j*2*pi*n*k/N);
 end
x(n+1)=sum(xn);
end
x=(1/N)*x;


