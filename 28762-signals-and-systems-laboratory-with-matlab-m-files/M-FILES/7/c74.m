% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


% Discrete Fourier Transform  X(k)



% DFT of x[n]=[1,2,2,1], n=0,1,2,3
x=[1 2 2 1];
N=length(x);
for k=0:N-1
    for  n=0:N-1
       X(n+1)=x(n+1)*exp(-j*2*pi*k*n/N);
    end
    Xk(k+1)=sum(X);
end
Xk
mag=abs(Xk);
stem(0:N-1,mag);
legend ('|X_k|')
xlim([-.5  3.5]); 
ylim([-.5  6.5]);
figure
phas=angle(Xk);
stem(0:N-1,phas);
legend ('\angle Xk')
xlim([-.4  3.4]);
ylim([-3.5  3]);  


% Polar form
mag.*exp(j*phas)

% Re{X(k)}
figure
re=real(Xk);
stem(0:N-1,re);
xlim([-.4  3.4]);
ylim([-1.5 6.5]);
legend ('real Xk')

% Im{X(k)}
figure
im=imag(Xk);
stem(0:N-1,im);
xlim([-.4  3.4]);
ylim([-1.5 1.5]);
legend ('imag Xk')
re+j*im

% Re{X(k)}
for k=0:N-1
  for n=0:N-1
    Xre(n+1)=x(n+1)*cos(2*pi*k*n/N);
  end
  Xr(k+1)=sum(Xre);
end
Xr

% Im{X(k)}
Xim=zeros(size(x))
N=length(x);
for k=1:N-1
  for n=0:N-1
    Xima(n+1)=x(n+1)*sin(2*pi*k*n/N);
  end
  Xim(k+1) = -sum(Xima);
end
Xim
