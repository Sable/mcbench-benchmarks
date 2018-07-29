% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


% DTFT properties

% convolution
n=0:5;
x=1./(n+1);
h=0.9.^n;
y=conv(x,h);
n1=0:10;
Y= sum(y.*exp(-j*w*n1));
subplot(211);
ezplot(abs(Y),[-pi pi]);
title('Magnitude of Y(\omega)')
subplot(212);
w1=-pi:.01:pi;
Y1=subs(Y,w,w1);
plot(w1,angle(Y1));
title('Angle of Y(\omega)')
xlim([-pi pi])


figure
xx=[x 0 0 0 0 0];
hh=[h 0 0 0 0 0];
X= sum(xx.*exp(-j*w*n1));
H= sum(hh.*exp(-j*w*n1));
Y=X.*H;
subplot(211);
ezplot(abs(Y),[-pi pi]);
title('Magnitude of X(\omega)H(\omega)')
subplot(212);
Y1=subs(Y,w,w1);
plot(w1,angle(Y1));
title('Angle of X(\omega)H(\omega)')
xlim([-pi pi])

