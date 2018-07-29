% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
% problem 5 - Computation of circular convolution

% a)

x1=[1 2 3 4];
x2=[ 5 4 3 2 1];
x1=[x1 0];
N=length(x1);
for m=0:N-1
x2s(1+m)=x2(1+ mod(-m,N));
end
for n=0:N-1
x2sn=circshift(x2s',n);
y(n+1)=x1*x2sn;
end
y


% b)
X1=fft(x1,N);
X2=fft(x2,N);
y=ifft(X1.*X2)
