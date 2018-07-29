% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
% problem 7 - DTFT and DFT of 0.7^n,0<=n<=19

n=0:19;
x=0.7.^n;
syms w
Xdtft=sum(x.*exp(-j*w*n));
Xdft=dft(x);
N=length(Xdft);
k=0:N-1;
wk=2*pi*k/N;
ezplot(abs(Xdtft), [0 2*pi]);
hold on
plot(wk,abs(Xdft),'o')
legend('Xdtft', 'Xdft')
