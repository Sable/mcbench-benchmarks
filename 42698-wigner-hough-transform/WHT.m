% WHT.m creates a chirp signal and perform Wigner-Hough transform on it.
clear
t1=0:0.001:1; 
N1 = length(t1);
sig = chirp(t1,100,1,20);
sig = hilbert(sig);
% Signal in time domain
figure(1);
subplot(221);
plot(t1,real(sig));
xlabel('t');
ylabel('A');
sig_n = awgn(sig,-3);
subplot(222)
plot(t1, real(sig_n));
% Wigner-Ville Distribution
[tfr,t,f] = wv(sig);
% f = f * (N1-1)/2/N1;
t = t * 1/1000;
[F, T] = meshgrid(f, t);
subplot(223);
mesh(F, T, abs(tfr));
subplot(224);
contour(f,t,abs(tfr));
xlabel('f');
ylabel('t');
% Hough Transform
[ht, rho, theta] = hough(tfr, f, t);
figure;
mesh(theta*180/pi, rho, abs(ht)); 
xlabel('theta'); ylabel('rho'); 
figure; image(theta*(180/pi), rho, abs(ht));
xlabel('theta'); ylabel('rho'); 

