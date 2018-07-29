% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%                                         
% Problem 7- Frequency Response and Impulse Response of an ideal bandpass
% filter 



td=.05;
B1=10 ;
B2=20;
w1=-30:-B2;
H1=zeros(size(w1));
w2=-B2:-B1;
H2=exp(-j*w2*td);
w3=-B1:B1;
H3=zeros(size(w3));
w4=B1:B2;
H4= exp(-j*w4*td);
w5=B2:30;
H5=zeros(size(w5));
w=[w1 w2 w3 w4 w5];
H=[H1 H2 H3 H4 H5];
plot(w,abs(H))
ylim([-.2 1.2]);
legend(' |H(\Omega) | ')

figure
plot(w,angle(H));
ylim([-1.1 1.1]);
legend('\angle H(\Omega)')



figure
syms t w
H1=exp(-j*w*td)*(heaviside(w+B2)-heaviside(w+B1));
H2=exp(-j*w*td)*(heaviside(w-B1)-heaviside(w-B2));
h1=ifourier(H1,t);
h2=ifourier(H2,t);
h=h1+h2;
ezplot(h, [-3 3]);
ylim([-4 4]);
legend('Impulse response h(t) ')

