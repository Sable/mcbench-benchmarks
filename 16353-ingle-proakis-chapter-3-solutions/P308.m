% P3.8
colordef white; clear;  clc;
M = 250;    k = -M:M;   w = (pi/M)*k;   % [0, pi] axis divided into 501 points.

n = -50:50;
x = exp(j*0.1*pi*n).*(stepseq(0,-50,50)-stepseq(20,-50,50)); 
[xe,xo,m] = evenoddcomplex(x,n);
xr = real(x);               xi = imag(x);
XE = dft(xe,length(m));     XO = dft(xo,length(m));
fXE = idft(XE,length(XE));  fXO = idft(XO,length(XO));
figure(1); 
subplot(2,2,1); plot(m,fXE,'k'); axis tight;
xlabel('frequency in pi units'); title('Conjugate Symmetric Part Inverse Fourier Transform'); ylabel('|XE-1|');
subplot(2,2,3); plot(m,fXO,'k'); axis tight;
xlabel('frequency in pi units'); title('Conjugate Antisymmetric Part Inverse Fourier Transform'); ylabel('|XO-1|');
subplot(2,2,2); plot(m,xr,'k');  axis tight;
xlabel('frequency in pi units'); title('Real part of x(n)'); ylabel('Re((x(n))');
subplot(2,2,4); plot(m,xi,'k');    axis tight;
xlabel('frequency in pi units'); title('Imaginary part of x(n)'); ylabel('Im(x(n))');