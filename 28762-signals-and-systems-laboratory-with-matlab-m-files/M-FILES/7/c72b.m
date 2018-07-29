% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


% DTFT properties

%time shifting 

syms w
n= 0:3;
x=[1,2,3,4] ;
n=0 :5 ;
xn0=[0 0 x]; %x[n-n0]=[0,0,1,2,3,4]
Left=sum(xn0.*exp(-j*w*n));
ezplot(abs(Left),[-pi pi])
title('| DTFT(x[n-n_0]) |')
ylim([2 11]) ;
figure
w1=-pi:.01:pi;
L=subs(Left,w,w1);
plot(w1,angle(L));
xlim([-pi pi])
title('Phase of DTFT')


figure
n=0:3;
n0=2;
x=[1,2,3,4];
X= sum(x.*exp(-j*w*n));
R=X.*exp(-j*w*n0);
w1=-pi:.01:pi;
R=subs(R,w,w1);
plot(w1,abs(R));
title('Magnitude of right part')
ylim([2 11]) ;
xlim([-pi pi])
figure
plot(w1,angle(R));
xlim([-pi pi])
title('Phase of right part')
xlim([-pi pi])

