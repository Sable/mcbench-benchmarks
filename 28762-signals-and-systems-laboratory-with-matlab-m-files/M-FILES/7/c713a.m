% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


% problem 1- DTFT of cos(n*pi/3)

syms w
n=0:10;
x=cos((1/3)*pi*n);
X=sum(x.*exp(-j*w*n));
ezplot(abs(X), [-pi pi])
legend('|DTFT|, -\pi<\omega<\pi')

figure
w1=-pi:.01:pi;
XX=subs(X,w,w1);
plot(w1,angle(XX))
xlim([-pi pi]);
legend('\angle DTFT,-\pi<\omega<\pi')

figure
ezplot(abs(X), [-3*pi 3*pi])
legend('|DTFT|, -3\pi<\omega<3\pi')

figure
w1=-3*pi:.01:3*pi;
XX=subs(X,w,w1);
plot(w1,angle(XX));
legend('\angle DTFT, -3\pi<\omega<3\pi')
xlim([-3*pi 3*pi]);
