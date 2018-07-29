% P3.11
colordef white; clear;  clc;
M = 250;    k = -M:M;   w = (pi/M)*k;   % [0, pi] axis divided into 501 points.
w0 = pi/2;  figure(1); 
n = -50:50;

h = (0.9).^(abs(n)); 
H = dtft(h,n,w); 
subplot(3,2,1); plot(w/pi,abs(H),'k');
xlabel('frequency in pi units');    ylabel('|H|');  title('Magnitude Response');
subplot(3,2,2); plot(w/pi,angle(H)/pi,'k'); 
xlabel('frequency in pi units');    ylabel('\Theta');   title('Phase Response');

h = sinc(0.2*n).*((stepseq(-20,-50,50)-stepseq(20,-50,50)));
H = dtft(h,n,w);
subplot(3,2,3); plot(w/pi,abs(H),'k');
xlabel('frequency in pi units');    ylabel('|H|');  title('Magnitude Response');
subplot(3,2,4); plot(w/pi,angle(H)/pi,'k'); 
xlabel('frequency in pi units');    ylabel('\Theta');   title('Phase Response');

h = sinc(0.2*n).*((stepseq(0,-50,50)-stepseq(40,-50,50))); 
H = dtft(h,n,w);
subplot(3,2,5); plot(w/pi,abs(H),'k');
xlabel('frequency in pi units');    ylabel('|H|');  title('Magnitude Response');
subplot(3,2,6); plot(w/pi,angle(H)/pi,'k'); 
xlabel('frequency in pi units');    ylabel('\Theta');   title('Phase Response');

figure(2); 
h = ((0.5).^n+(0.4).^n).*stepseq(0,-50,50); 
H = dtft(h,n,w);
subplot(3,2,1); plot(w/pi,abs(H),'k');
xlabel('frequency in pi units');    ylabel('|H|');  title('Magnitude Response');
subplot(3,2,2); plot(w/pi,angle(H)/pi,'k'); 
xlabel('frequency in pi units');    ylabel('\Theta');   title('Phase Response');

h = (0.5).^(abs(n)).*cos(0.1*pi*n); 
H = dtft(h,n,w);
subplot(3,2,3); plot(w/pi,abs(H),'k');
xlabel('frequency in pi units');    ylabel('|H|');  title('Magnitude Response');
subplot(3,2,4); plot(w/pi,angle(H)/pi,'k'); 
xlabel('frequency in pi units');    ylabel('\Theta');   title('Phase Response');