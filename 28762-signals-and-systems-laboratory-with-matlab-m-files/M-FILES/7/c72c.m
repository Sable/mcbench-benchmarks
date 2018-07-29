% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


% DTFT properties

%frequency shifting 

syms w
w0= 3;
n= 0:10;
x=0.8.^n ;
L=x.*exp(j*w0*n) ;
Left=sum(L.*exp(-j*w*n));
ezplot(abs(Left),[-pi pi])
title('| DTFT(x[n]exp(3jn)) |')
figure
w1=-pi:.01:pi;
L=subs(Left,w,w1);
plot(w1,angle(L));
xlim([-pi pi])
title('Phase of DTFT')

figure
X= sum(x.*exp(-j*w*n));
R=subs(X,w,w-w0);
ezplot(abs(R),[-pi pi]);
title('Magnitude of right part')
figure
w1=-pi:.01:pi;
R=subs(R,w,w1);
plot(w1,angle(R));
xlim([-pi pi])
title('Phase of right part')
xlim([-pi pi])

