% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


% Relationship between DFT and DTFT. 
% x[n] is random sequence 

x=randn(1,21);
n=0:20;
syms w
Xdtft=sum(x.*exp(-j*w*n));
Xdft=fft(x);
N=length(Xdft);
k=0:N-1;
wk=2*pi*k/N;
ezplot(abs(Xdtft),[0  2*pi]);
hold on
plot(wk,abs(Xdft),'o')
hold off 
legend('DTFT','DFT')

figure
w1=0:.01:2*pi;
XXdtft=subs(Xdtft,w,w1);
plot(w1,angle(XXdtft));
hold on
plot(wk,angle(Xdft),'o')
legend('DTFT','DFT')
hold off 

