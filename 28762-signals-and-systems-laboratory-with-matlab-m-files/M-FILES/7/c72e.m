% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


% DTFT properties

% Differentiation in frequency

syms n
x=0.8.^n
L=symsum(n/j*x*exp(-j*w*n),n,0,inf);
subplot(211);
w1=-pi:.01:pi;
Li=subs(L,w,w1);
plot(w1,abs(Li));
legend('magnitude of DTFT of left part')
subplot(212);
plot(w1,angle(Li))
legend('angle of DTFT of left part')

figure
syms n w
X=1/(1-0.8*exp(-j*w));
R=diff(X,w);
subplot(211);
w1=-pi:.01:pi;
Ri=subs(R,w,w1);
plot(w1,abs(Ri));
legend('magnitude of right part')
subplot(212);
plot(w1,angle(Ri))
legend('angle of right part')

