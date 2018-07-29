% P3.9
colordef white; clear;  clc;
M = 250;    k = -M:M;   w = (pi/M)*k;   % [0, pi] axis divided into 501 points.
w0 = pi/2;  figure(1); 

N = 5;
n = [-N-10:N+10];
x = stepseq(-N,-N-10,N+10)-stepseq(N+1,-N-10,N+10); 
x = cos(w0*n).*x; 
X = dtft(x,n,w); 
subplot(3,3,1); plot(w/pi,abs(X),'k');
xlabel('frequency in pi units'); title('Fourier Transform Magnitude N = 5'); ylabel('|X|');
subplot(3,3,4); plot(w/pi,angle(X),'k');
xlabel('frequency in pi units'); title('Fourier Transform Phase N = 5'); ylabel('\theta');

N = 15;
n = [-N-10:N+10];
x = stepseq(-N,-N-10,N+10)-stepseq(N+1,-N-10,N+10); 
x = cos(w0*n).*x; 
X = dtft(x,n,w); 
subplot(3,3,2); plot(w/pi,abs(X),'k');
xlabel('frequency in pi units'); title('Fourier Transform Magnitude N = 15'); ylabel('|X|');
subplot(3,3,5); plot(w/pi,angle(X),'k');
xlabel('frequency in pi units'); title('Fourier Transform Phase N = 15'); ylabel('\theta')

N = 25;
n = [-N-10:N+10];
x = stepseq(-N,-N-10,N+10)-stepseq(N+1,-N-10,N+10); 
x = cos(w0*n).*x; 
X = dtft(x,n,w); 
subplot(3,3,3); plot(w/pi,abs(X),'k');
xlabel('frequency in pi units'); title('Fourier Transform Magnitude N = 25'); ylabel('|X|');
subplot(3,3,6); plot(w/pi,angle(X),'k');
xlabel('frequency in pi units'); title('Fourier Transform Phase N = 25'); ylabel('\theta')

N = 100;
n = [-N-10:N+10];
x = stepseq(-N,-N-10,N+10)-stepseq(N+1,-N-10,N+10); 
x = cos(w0*n).*x; 
X = dtft(x,n,w); 
subplot(3,2,5); plot(w/pi,abs(X),'k');
xlabel('frequency in pi units'); title('Fourier Transform Magnitude N = 100'); ylabel('|X|');
subplot(3,2,6); plot(w/pi,angle(X),'k');
xlabel('frequency in pi units'); title('Fourier Transform Phase N = 100'); ylabel('\theta')