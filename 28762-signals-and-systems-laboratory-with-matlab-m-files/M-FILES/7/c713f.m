% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
% problem 6 - Computation of linear convolution


% a)
x1=[1 2 3 4];
x2=[ 5 4 3 2 1];
y=conv(x1,x2)

% b)
N1=length(x1);
N2=length(x2);
M=N1+N2-1;
x1(M)=0;
x2(M)=0;
y=circonv(x1,x2)

% c)
X1=fft(x1,M);
X2=fft(x2,M);
y=ifft(X1.*X2)
