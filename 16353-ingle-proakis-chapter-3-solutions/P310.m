% P3.10
colordef white; clear;  clc;
M = 250;    k = -M:M;   w = (pi/M)*k;   % [0, pi] axis divided into 501 points.
w0 = pi/2;  figure(1); 

n=[-25,25];
h=(0.9).^(abs(n)); 
H=dtft(h,n,w); 
subplot(2,1,1); 
plot(w/pi,abs(H)); grid; 
xlabel('frequency in pi units'); 
ylabel('|H|'); 
title('Impulse Response Magnitude');
subplot(2,1,2); 
plot(w/pi,angle(H)/pi); 
grid; 
xlabel('frequency in pi units'); 
ylabel('\Theta'); 
title('Impulse Response Phase');