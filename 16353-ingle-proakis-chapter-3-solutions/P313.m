% P3.13
colordef white; clear;  clc;
M = 250;    k = -M:M;   w = (pi/M)*k;   % [0, pi] axis divided into 501 points.
w0 = pi/2;  figure(1); 

alpha=20;   wc=0.5*pi;  n = 0:40;
h = sin(wc*(n-alpha))./(pi*(n-alpha)); 
h(21) = 1/exp(1); 
subplot(3,1,1); plot(n,h,'k');
xlabel('n');    ylabel('h(n)'); title('Truncated Impulse Response');
H = dtft(h,n,w);
subplot(3,1,2); plot(w/pi,abs(H),'k');
xlabel('frequency in pi units');    ylabel('|H|');  title('Magnitude Response');
subplot(3,1,3); plot(w/pi,angle(H)/pi,'k'); 
xlabel('frequency in pi units');    ylabel('\Theta');   title('Phase Response');