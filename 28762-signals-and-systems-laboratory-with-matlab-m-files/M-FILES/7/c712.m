% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


% linear convolution computation via FFT

x1=[1 2 0 5];
x2=[ 3 2 1];
N1=4;
N2=3;
N=N1+N2-1;
X1=fft(x1,N);
X2=fft(x2,N);
PROD=X1.*X2;
CON=ifft(PROD)

y=conv(x1,x2)

