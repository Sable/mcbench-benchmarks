% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
% this function  computes the Discrete Fourier Transform X of a sequence x


function Xk = dft(x);
N=length(x);
 for k=0:N-1
    for n=0:N-1
      X(n+1)=x(n+1)*exp(-j*2*pi*k*n/N);
    end
    Xk(k+1)=sum(X);
end

