% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


% Relationship between DFT and Fourier Transform  


T=.1;
N=128;
t=0:1/(N*T):2;
x=2-3*t;
Xk=fft(x,N);

k=0:N-1;
wk=2*pi*k/(N*T);
Xwk=(N*T*(1-exp(-j*2*pi*k/N))./(j*2*pi*k)).*Xk;

syms t w
x=(2-3*t)*(heaviside(t)- heaviside(t-2));
X=fourier(x,w);

ezplot(abs(X),[0 wk(N)]);
hold on
plot(wk,abs(Xwk),':o')
hold off
legend('X(\Omega)','X(\Omega_k)')
ylim([0 4])
title(' CTFT and DFT ')
