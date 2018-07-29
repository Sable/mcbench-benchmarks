%P3.5
colordef white; clear;  clc;
M = 250;    k = -M:M;   w = (pi/M)*k;   % [0, pi] axis divided into 501 points.

N = 5;  nx = [-N-10:N+10];
x = stepseq(-N,-N-10,N+10)-stepseq(N+1,-N-10,N+10);
x = (1-abs(nx)/N).*x;
X = dtft(x,nx,w);           % Computes Discrete-Time Fourier Transform
magX = abs(X);  magX = magX./max(magX); angX = angle(X); figure(1); 
subplot(3,2,1); stem(nx,x,'k');
xlabel('n'); title('Given Sequence at N = 5'); ylabel('x1(n)')
subplot(3,2,3); plot(w/pi,magX,'k');
xlabel('frequency in pi units'); title('Magnitude Part'); ylabel('Magnitude')
subplot(3,2,5); plot(w/pi,angX,'k');
xlabel('frequency in pi units'); title('Angle Part'); ylabel('Radians')

N = 15; nx = [-N-10:N+10];
x = stepseq(-N,-N-10,N+10)-stepseq(N+1,-N-10,N+10);
x = (1-abs(nx)/N).*x;
X = dtft(x,nx,w);           % Computes Discrete-Time Fourier Transform
magX = abs(X);  magX = magX./max(magX); angX = angle(X); figure(1); 
subplot(3,2,2); stem(nx,x,'k');
xlabel('n'); title('Given Sequence at N = 15'); ylabel('x1(n)')
subplot(3,2,4); plot(w/pi,magX,'k');
xlabel('frequency in pi units'); title('Magnitude Part'); ylabel('Magnitude')
subplot(3,2,6); plot(w/pi,angX,'k');
xlabel('frequency in pi units'); title('Angle Part'); ylabel('Radians')

N = 25;  nx = [-N-10:N+10];
x = stepseq(-N,-N-10,N+10)-stepseq(N+1,-N-10,N+10);
x = (1-abs(nx)/N).*x;
X = dtft(x,nx,w);           % Computes Discrete-Time Fourier Transform
magX = abs(X);  magX = magX./max(magX); angX = angle(X); figure(2); 
subplot(3,2,1); stem(nx,x,'k');
xlabel('n'); title('Given Sequence at N = 25'); ylabel('x1(n)')
subplot(3,2,3); plot(w/pi,magX,'k');
xlabel('frequency in pi units'); title('Magnitude Part'); ylabel('Magnitude')
subplot(3,2,5); plot(w/pi,angX,'k');
xlabel('frequency in pi units'); title('Angle Part'); ylabel('Radians')

N = 100; nx = [-N-10:N+10];
x = stepseq(-N,-N-10,N+10)-stepseq(N+1,-N-10,N+10);
x = (1-abs(nx)/N).*x;
X = dtft(x,nx,w);           % Computes Discrete-Time Fourier Transform
magX = abs(X);  magX = magX./max(magX); angX = angle(X); figure(2); 
subplot(3,2,2); stem(nx,x,'k');
xlabel('n'); title('Given Sequence at N = 100'); ylabel('x1(n)')
subplot(3,2,4); plot(w/pi,magX,'k');
xlabel('frequency in pi units'); title('Magnitude Part'); ylabel('Magnitude')
subplot(3,2,6); plot(w/pi,angX,'k');
xlabel('frequency in pi units'); title('Angle Part'); ylabel('Radians')