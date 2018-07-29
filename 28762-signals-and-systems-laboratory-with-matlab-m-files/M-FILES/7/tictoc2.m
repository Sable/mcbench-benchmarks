% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
% This script measures the execution speed of a N-point  
% FFT algorithm with respect to the value of N.


N=2^20
n=0:N-1;
x=(-1).^n;
tic
X=fft(x);
toc

N=950000
n=0:N-1;
x=(-1).^n;
tic
X=fft(x);
toc

N=850000
n=0:N-1;
x=(-1).^n;
tic
X=fft(x);
toc

N=750000
n=0:N-1;
x=(-1).^n;
tic
X=fft(x);
toc

N=650000
n=0:N-1;
x=(-1).^n;
tic
X=fft(x);
toc
