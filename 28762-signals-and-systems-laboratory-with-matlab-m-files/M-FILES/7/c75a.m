% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


% Discrete Fourier Transform  properties


% periodicity


n=0:4;
x=n.^2;
X=dft(x)
N=length(x);
for k=0:N-1+N
  for  n=0:N-1
    X(n+1)=x(n+1)*exp(-j*2*pi*k*n/N);
  end
  XkN(k+1)=sum(X);
end
XkN
mag=abs(XkN);
stem(0:N-1+N,mag);
legend ('| X_k_+_N |')
xlim([-.5  9.5]);
ylim([-1  32]);
figure
phas=angle(XkN);
stem(0:N-1+N,phas);
legend ('\angle X_k_+_N')
xlim([-.5  9.5]); 
