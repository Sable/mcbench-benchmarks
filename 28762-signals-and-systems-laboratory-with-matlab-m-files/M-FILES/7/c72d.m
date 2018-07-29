% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


% DTFT properties

%time reversal

syms w
n= -5 :0;
x=-n
Left=sum(x.*exp(-j*w*n));
ezplot(abs(Left),[-pi pi])
title('| DTFT(x[-n]) |')
figure
w1=-pi:.01:pi;
LL=subs(Left,w,w1)
plot(w1,angle(LL));
xlim([-pi pi])
title('\angle DTFT(x[-n])')

figure
n=0:5;
x=n;
X= sum(x.*exp(-j*w*n));
Right=subs(X,w,-w) ;
ezplot(abs(Right),[-pi pi])
title('Magnitude of right part')
figure
w1=-pi:.01:pi;
RR=subs(Right,w,w1)
plot(w1,angle(RR));
xlim([-pi pi])
title('Phase of right part')
