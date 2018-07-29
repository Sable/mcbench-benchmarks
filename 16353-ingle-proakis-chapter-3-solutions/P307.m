% P3.7
colordef white; clear;  clc;
M = 250;    k = -M:M;   w = (pi/M)*k;   % [0, pi] axis divided into 501 points.

n = -50:50;
x = exp(j*0.1*pi*n).*(stepseq(0,-50,50)-stepseq(20,-50,50)); 
[xe,xo,m] = evenoddcomplex(x,n);
XE = dtft(xe,m,w);  XO = dtft(xo,m,w); 

figure(1); 
subplot(2,2,1); plot(w/pi,abs(XE),'k'); axis tight;
xlabel('frequency in pi units'); title('Conjugate Symmetric Part Fourier Transform'); ylabel('|XE|');
subplot(2,2,3); plot(w/pi,abs(XO),'k'); axis tight;
xlabel('frequency in pi units'); title('Conjugate Antisymmetric Part Fourier Transform'); ylabel('|XO|');
subplot(2,2,2); plot(w/pi,abs(real(dtft(x,n,w))),'k');  axis tight;
xlabel('frequency in pi units'); title('Real part of DTFT(x)'); ylabel('|Re(DTFT(x))|');
subplot(2,2,4); plot(w/pi,abs(j*imag(dtft(x,n,w))),'k');    axis tight;
xlabel('frequency in pi units'); title('Imaginary part of DTFT(x)'); ylabel('|Im(DTFT(x))|');