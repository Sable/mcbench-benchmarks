% Example file for function fourier_series_real
% for details type:  'help fourier_series_real'
 % Written by Yoash Levron, January 2013.

%%% build example signal - abs(sin(wt))
f = 50;  % Hz
t = 0:0.001:0.02;
x = abs(sin(2*pi*50*t));
% x = 2 + 3*cos(2*pi*50*t);

%%% compute fourier transform:
[ freq,amp,phase,dc ] = fourier_series_real( t,x );

%%% display results:
close all;
figure(1);
plot(t,x);
xlabel('time [sec]');
title('signal:  x(t)');

figure(2);
subplot(2,1,1);
stem(freq,amp);
hold on;
stem(0,dc);
xlim([0 500]);
ylabel('amplitude');

subplot(2,1,2);
stem(freq,phase*180/pi); ylabel('phase [deg]');
xlabel('frequency [Hz]');
 xlim([0 500]);


