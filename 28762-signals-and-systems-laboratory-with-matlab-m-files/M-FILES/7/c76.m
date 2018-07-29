% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


% Inverse DFT of X(k)=[6, -1-j,0,-1+j], k=0,1,2,3


clear; 
Xk=[6, -1-j,0,-1+j];
N=length(Xk);
for n=0:N-1
for k=0:N-1
xn(k+1)=Xk(k+1)*exp(j*2*pi*n*k/N);
end
x(n+1)=sum(xn);
end
x=(1/N)*x


