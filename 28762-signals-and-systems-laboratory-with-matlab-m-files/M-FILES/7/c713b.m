% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


% problem 2 - DFT of cos(n*pi/3)

n=0:10;
x=cos((1/3)*pi*n);
Xk=fft(x);
N=length(x);
k=0:N-1;
stem(k,abs(Xk));
xlim([-.5 10.5]);
legend('|X_k|')

figure
stem(k,angle(Xk));
xlim([-.5 10.5]);
legend('\angle X_k')

figure
stem(k,real(Xk));
xlim([-.5 10.5]);
legend(' RE[X_k]')

figure
stem(k,imag(Xk));
xlim([-.5 10.5]);
legend(' IM[X_k]')
