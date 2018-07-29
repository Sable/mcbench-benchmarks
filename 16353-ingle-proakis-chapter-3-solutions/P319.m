% P3.19
% Señal Analógica 
clear;  clc;    colordef white;
Dt=0.0005;  t=-.5:Dt:0.5;   xa=3*cos(20*pi*t); 
subplot(2,2,1); plot(t,xa,'k'); xlabel('Frequency');    ylabel('Amplitude');
title('Analog Input Signal x_a(t)'); 
% Señal en tiempo discreto 
Ts=0.01;    n=-50:1:50;     nTs=n*Ts; 
x=3*cos(20*pi*nTs); 
subplot(2,2,3); stem(n,x,'k'); xlabel('Frequency'); ylabel('Amplitude');
title('Discrete Input Signal x(n)'); 
% x(n)*h(n) 
h=((0.5).^n).*stepseq(0,-50,50);
[y,n]=conv_m(x,n,h,n);
subplot(2,2,2); stem(n,y,'k'); xlabel('Frequency'); ylabel('Amplitude');
title('Discrete Output Signal y(n)'); 
% Señal de salida reconstruida ya(t) 
Dt=0.0005;  t=-0.50:Dt:0.50;    Ts=0.01;    Fs=1/Ts;    nTs=n*Ts;
ya=y*sinc(Fs*(ones(length(n),1)*t-nTs'*ones(1,length(t))));
subplot(2,2,4); plot(t,ya,'k'); xlabel('Frequency');    ylabel('Amplitude');
title('Analog Output Signal y_a(t)');

figure(2);
% Señal Analógica 
Dt=0.0005;  t=-.5:Dt:0.5;   xa=3*[t>=0];
subplot(2,2,1); plot(t,xa,'k'); xlabel('Frequency');   ylabel('Amplitude');
title('Analog Input Signal x_a(t)'); 
% Señal en tiempo discreto 
Ts=0.01;    n=-50:1:50;nTs=n*Ts;    x=3*[nTs>=0];
subplot(2,2,3); stem(n,x,'k');  xlabel('Frequency');   ylabel('Amplitude');
title('Discrete Input Signal x(n)'); 
% x(n)*h(n)
h = ((0.5).^n).*stepseq(0,-50,50);  [y,n]=conv_m(x,n,h,n);
subplot(2,2,2); stem(n,y,'k');  xlabel('Frequency');   ylabel('Amplitude');
title('Discrete Output Signal y(n)'); 
% Señal de salida reconstruida ya(t) 
Dt=0.0005;  t=-0.50:Dt:0.50;    Ts=0.01;    Fs=1/Ts;nTs=n*Ts;
ya=y*sinc(Fs*(ones(length(n),1)*t-nTs'*ones(1,length(t))));
subplot(2,2,4); plot(t,ya,'k'); xlabel('Frequency');   ylabel('Amplitude');
title('Analog Output Signal y_a(t)');