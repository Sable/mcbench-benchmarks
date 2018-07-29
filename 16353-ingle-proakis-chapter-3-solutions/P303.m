%P3.3
clear;  clc;
colordef white;
M = 250;
k = -M:M;
w = (pi/M)*k;               % [0, pi] axis divided into 501 points.

[x,nx] = stepseq(0,-10,10); % sequence x1(n)
x=3*0.9^3*x;
X = dtft(x,nx,w);           % Computes Discrete-Time Fourier Transform
magX = abs(X); angX = angle(X);
figure(1); 
subplot(3,2,1); stem(nx,x,'k');
xlabel('n'); title('Given Sequence'); ylabel('x1(n)')
subplot(3,2,3); plot(w/pi,magX,'k');
xlabel('frequency in pi units'); title('Magnitude Part'); ylabel('Magnitude')
subplot(3,2,5); plot(w/pi,angX,'k');
xlabel('frequency in pi units'); title('Angle Part'); ylabel('Radians')

[x,nx] = stepseq(2,-10,10); % sequence x2(n)
[x,nx] = sigmult(x,nx,2*0.8.^(nx+2),nx);
X = dtft(x,nx,w);           % Computes Discrete-Time Fourier Transform
magX = abs(X); angX = angle(X);
subplot(3,2,2); stem(nx,x,'k');
xlabel('n'); title('Given Sequence'); ylabel('x2(n)')
subplot(3,2,4); plot(w/pi,magX,'k');
xlabel('frequency in pi units'); title('Magnitude Part'); ylabel('Magnitude')
subplot(3,2,6); plot(w/pi,angX,'k');
xlabel('frequency in pi units'); title('Angle Part'); ylabel('Radians')

[x,nx] = stepseq(0,-10,10); % sequence x3(n)
[x,nx] = sigmult(x,nx,0.5.^nx,nx);
[x,nx] = sigmult(x,nx,nx,nx);
X = dtft(x,nx,w);           % Computes Discrete-Time Fourier Transform
magX = abs(X); angX = angle(X);
figure(2); 
subplot(3,2,1); stem(nx,x,'k');
xlabel('n'); title('Given Sequence'); ylabel('x3(n)')
subplot(3,2,3); plot(w/pi,magX,'k');
xlabel('frequency in pi units'); title('Magnitude Part'); ylabel('Magnitude')
subplot(3,2,5); plot(w/pi,angX,'k');
xlabel('frequency in pi units'); title('Angle Part'); ylabel('Radians')

[x,nx] = stepseq(2,-10,10); % sequence x4(n)
[x,nx] = sigmult(x,nx,-0.7.^(nx-1),nx);
[x,nx] = sigmult(nx+2,nx,x,nx);
X = dtft(x,nx,w);           % Computes Discrete-Time Fourier Transform
magX = abs(X); angX = angle(X);
subplot(3,2,2); stem(nx,x,'k');
xlabel('n'); title('Given Sequence'); ylabel('x4(n)')
subplot(3,2,4); plot(w/pi,magX,'k');
xlabel('frequency in pi units'); title('Magnitude Part'); ylabel('Magnitude')
subplot(3,2,6); plot(w/pi,angX,'k');
xlabel('frequency in pi units'); title('Angle Part'); ylabel('Radians')

[x,nx] = stepseq(0,-10,10); % sequence x5(n)
[x,nx] = sigmult(cos(0.1*pi*nx),nx,x,nx);
[x,nx] = sigmult(5*(-0.9).^nx,nx,x,nx);
X = dtft(x,nx,w);           % Computes Discrete-Time Fourier Transform
magX = abs(X); angX = angle(X);
figure(3);
subplot(3,2,1); stem(nx,x,'k');
xlabel('n'); title('Given Sequence'); ylabel('x5(n)')
subplot(3,2,3); plot(w/pi,magX,'k');
xlabel('frequency in pi units'); title('Magnitude Part'); ylabel('Magnitude')
subplot(3,2,5); plot(w/pi,angX,'k');
xlabel('frequency in pi units'); title('Angle Part'); ylabel('Radians')