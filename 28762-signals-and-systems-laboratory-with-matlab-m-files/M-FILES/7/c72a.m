% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


% DTFT properties

%linearity

syms w
n= 0:10;
x1=0.8.^n;
x2=0.7.^n;
a=3; b=4;
L=a*x1+b*x2;
Left=sum(L.*exp(-j*w*n));
ezplot(abs(Left),[-pi pi])
title('| DTFT(ax_1[n]+bx_2[n]) |')
figure
w1=-pi:.01:pi;
LL=subs(Left,w,w1)
plot(w1,angle(LL));
xlim([-pi pi])
title('Phase of DTFT')


figure
X1= sum(x1.*exp(-j*w*n));
X2= sum(x2.*exp(-j*w*n));
Right=a*X1+b*X2 ;
ezplot(abs(Right),[-pi pi])
title('Magnitude of right side')
figure
w1=-pi:.01:pi;
RR=subs(Right,w,w1)
plot(w1,angle(RR));
xlim([-pi pi])
title('Phase of right part')
