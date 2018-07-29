% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni



% DTFT of a discrete time signal x[n]


%x[n]=0.8^n , 0<=n<=20
syms w
n= 0:20;
x=0.8.^n;
X=sum(x.*exp(-j*w*n));
ezplot(abs(X),[-pi pi])
title(' Magnitude of DTFT')
ylim([0 5.4])

figure
w1=-pi:.01:pi;
XX=subs(X,w,w1)
plot(w1,angle(XX));
xlim([-pi pi])
title('Phase of DTFT')

figure
ezplot(abs(X),[-5*pi 5*pi]);
title('Magnitude of DTFT in 5 periods')
ylim([0 5.8])

figure
w1=-5*pi:.01:5*pi;
XX=subs(X,w,w1);
plot(w1,angle(XX));
xlim([-5*pi 5*pi])
title(' Phase of DTFT in 5 periods')



%x[n]=0.8^n u[n]
figure
syms n w
x=0.6^n
X=symsum(x*exp(-j*w*n),n,0,inf)
w1=-pi:.01:pi;
X_=subs(X,w,w1);
plot(w1,abs(X_));
legend('|X(\omega)|')
xlim([-pi pi])

figure
plot(w1,angle(X_));
xlim([-pi pi])
legend('\angle X(\omega)')


