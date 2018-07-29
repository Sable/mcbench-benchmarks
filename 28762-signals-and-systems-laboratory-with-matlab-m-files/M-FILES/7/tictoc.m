% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
% This script compares the execution speed of the 
% FFT algorithm versus the DFT algorithm 

N=20
n=0:N-1;
x=(-1).^n;

disp('DFT')
tic
X=dft(x);
toc

disp('FFT')
tic
X=fft(x);
toc


N=2^12
n=0:N-1;
x=(-1).^n;

disp('DFT')
tic
X=dft(x);
toc

disp('FFT')
tic
X=fft(x);
toc
