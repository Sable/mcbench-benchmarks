% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%                                         
%  	Ideal low pass filter



%Frequency Response
B= 10;
td=.05;
w1=-20:-B;
H1=zeros(size(w1));
w2=-B:B;
H2=exp(-j*w2*td);
w3=B:20;
H3=zeros(size(w3));
w=[w1 w2 w3];
H=[H1 H2 H3];
plot(w,abs(H));
ylim([-.2 1.2]);
legend(' Magnitude response');

figure
plot(w,angle(H));
ylim([-2*B*td 2*B*td]);
gtext('Bt_d')
gtext('-Bt_d')
gtext('B')
gtext('-B')
legend ('Phase response');



%Impulse response 
figure
syms t w
H=exp(-j*w*td)*(heaviside(w+B)-heaviside(w-B));
h=ifourier(H,t);
ezplot(h, [-5 5]);
ylim([-.8 3.5]);
title('Impulse response of an ideal low pass filter')
grid;
