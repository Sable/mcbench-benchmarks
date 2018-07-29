%P3.2
colordef white; clear;  clc;
M = 250;
k = -M:M;
w = (pi/M)*k;               % [0, pi] axis divided into 501 points.

[x,nx] = stepseq(0,-50,50); % sequence x1a(n)
[x2,nx2] = stepseq(20,-50,50); % sequence x1b(n)
[x,nx] = sigadd(x,nx,x2,nx2);
x2 = 2*0.8.^nx2;
[x,nx] = sigmult(x,nx,x2,nx2);
X = dtft(x,nx,w);           % Computes Discrete-Time Fourier Transform
magX = abs(X); angX = angle(X);
figure(1); 
subplot(3,2,1); stem(nx,x,'k');
xlabel('n'); title('Given Sequence'); ylabel('x1(n)')
subplot(3,2,3); plot(w/pi,magX,'k');
xlabel('frequency in pi units'); title('Magnitude Part'); ylabel('Magnitude')
subplot(3,2,5); plot(w/pi,angX,'k');
xlabel('frequency in pi units'); title('Angle Part'); ylabel('Radians')

[x,nx] = stepseq(0,0,100); % sequence x1a(n)
[x2,nx2] = stepseq(50,0,100); % sequence x1b(n)
[x,nx] = sigadd(x,nx,x2,nx2);
x2 = 0.9.^nx2;
[x,nx] = sigmult(x,nx,x2,nx2);
X = dtft(x,nx,w);           % Computes Discrete-Time Fourier Transform
magX = abs(X); angX = angle(X);
figure(1); 
subplot(3,2,2); stem(nx,x,'k');
xlabel('n'); title('Given Sequence'); ylabel('x2(n)')
subplot(3,2,4); plot(w/pi,magX,'k');
xlabel('frequency in pi units'); title('Magnitude Part'); ylabel('Magnitude')
subplot(3,2,6); plot(w/pi,angX,'k');
xlabel('frequency in pi units'); title('Angle Part'); ylabel('Radians')

x = [4,3,2,1,2,3,4];
nx = 0:length(x)-1;
X = dtft(x,nx,w);           % Computes Discrete-Time Fourier Transform
magX = abs(X); angX = angle(X);
figure(2); 
subplot(3,2,1); stem(nx,x,'k');
xlabel('n'); title('Given Sequence'); ylabel('x3(n)')
subplot(3,2,3); plot(w/pi,magX,'k');
xlabel('frequency in pi units'); title('Magnitude Part'); ylabel('Magnitude')
subplot(3,2,5); plot(w/pi,angX,'k');
xlabel('frequency in pi units'); title('Angle Part'); ylabel('Radians')

x = [4,3,2,1,1,2,3,4];
nx = 0:length(x)-1;
X = dtft(x,nx,w);           % Computes Discrete-Time Fourier Transform
magX = abs(X); angX = angle(X);
figure(2); 
subplot(3,2,2); stem(nx,x,'k');
xlabel('n'); title('Given Sequence'); ylabel('x4(n)')
subplot(3,2,4); plot(w/pi,magX,'k');
xlabel('frequency in pi units'); title('Magnitude Part'); ylabel('Magnitude')
subplot(3,2,6); plot(w/pi,angX,'k');
xlabel('frequency in pi units'); title('Angle Part'); ylabel('Radians')

x = 4:-1:-4;
nx = 0:length(x)-1;
X = dtft(x,nx,w);           % Computes Discrete-Time Fourier Transform
magX = abs(X); angX = angle(X);
figure(3); 
subplot(3,2,1); stem(nx,x,'k');
xlabel('n'); title('Given Sequence'); ylabel('x5(n)')
subplot(3,2,3); plot(w/pi,magX,'k');
xlabel('frequency in pi units'); title('Magnitude Part'); ylabel('Magnitude')
subplot(3,2,5); plot(w/pi,angX,'k');
xlabel('frequency in pi units'); title('Angle Part'); ylabel('Radians')

x = [4,3,2,1,-1,-2,-3,-4];
nx = 0:length(x)-1;
X = dtft(x,nx,w);           % Computes Discrete-Time Fourier Transform
magX = abs(X); angX = angle(X);
figure(3); 
subplot(3,2,2); stem(nx,x,'k');
xlabel('n'); title('Given Sequence'); ylabel('x6(n)')
subplot(3,2,4); plot(w/pi,magX,'k');
xlabel('frequency in pi units'); title('Magnitude Part'); ylabel('Magnitude')
subplot(3,2,6); plot(w/pi,angX,'k');
xlabel('frequency in pi units'); title('Angle Part'); ylabel('Radians')