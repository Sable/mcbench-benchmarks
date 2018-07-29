% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


% Relationship between DFT and DTFT. 
% The Transforms are plotted in -pi<w<pi


n=0:11;
x=0.9.^n;
syms w
Xdtft=sum(x.*exp(-j*w*n));
Xdft=fft(x);
Xdft.'

N=12;
k=-N/2: N/2-1;
wk=2*pi*k/N;
wk'

Xshift= fftshift(Xdft)
Xshift.'
ezplot(abs(Xdtft),[-pi,pi]);
hold ;
plot(wk,abs(Xshift),'o')
hold on
ylim([0 8])
legend('DTFT','DFT')
title('|DTFT| & |DFT|') 
hold off

figure
w1=-pi:.01:pi;
Xdtft=subs(Xdtft,w,w1);
plot(w1,angle(Xdtft));
hold on
plot(wk,angle(Xshift),'o')
legend('DTFT','DFT')
xlim([-pi pi])
title('\angle DTFT &\angle DFT')
hold off

