function [y Bitrate MSE Stepsize QNoise]=pcm(A,fm,fs,n)
%A=amplitute of cosine signal
%fm=frequency of cosine signal
%fs=sampling frequency
%n= number of bits per sample
%MSE=Mean Squar error, QNoise=Quantization Noise
%Example [y Bitrate MSE Stepsize QNoise]=pcm(2,3,20,3)
%If you have any problem or feedback please contact me @
%%===============================================
% NIKESH BAJAJ
% Asst. Prof., Lovely Professional University, India
% Almameter: Aligarh Muslim University, India
% +919915522564, bajaj.nikkey@gmail.com
%%===============================================

t=0:1/(100*fm):1;
x=A*cos(2*pi*fm*t);
%---Sampling-----
ts=0:1/fs:1;
xs=A*cos(2*pi*fm*ts);
%xs Sampled signal

%--Quantization---
x1=xs+A;
x1=x1/(2*A);
L=(-1+2^n); % Levels
x1=L*x1;
xq=round(x1);
r=xq/L;
r=2*A*r;
r=r-A;
%r quantized signal

%----Encoding---
y=[];
for i=1:length(xq)
    d=dec2bin(xq(i),n);
    y=[y double(d)-48];
end
%Calculations
MSE=sum((xs-r).^2)/length(x);
Bitrate=n*fs;
Stepsize=2*A/L;
QNoise=((Stepsize)^2)/12;

figure(1)
plot(t,x,'linewidth',2)
title('Sampling')
ylabel('Amplitute')
xlabel('Time t(in sec)')
hold on
stem(ts,xs,'r','linewidth',2)
hold off
legend('Original Signal','Sampled Signal');

figure(2)
stem(ts,x1,'linewidth',2)
title('Quantization')
ylabel('Levels L')
hold on
stem(ts,xq,'r','linewidth',2)
plot(ts,xq,'--r')
plot(t,(x+A)*L/(2*A),'--b')
grid
hold off
legend('Sampled Signal','Quantized Signal');

figure(3)
stairs([y y(length(y))],'linewidth',2)
title('Encoding')
ylabel('Binary Signal')
xlabel('bits')
axis([0 length(y) -1 2])
grid
