clear;  clc;
% P2.5
n = 0:10;
x = 10*exp(-j*0.4*pi*n);
[xe, xo, m] = evenoddcomplex(x,n);
subplot(3,2,1); stem(n,real(x),'ko'); title('Real Original Sequence')
xlabel('n'); ylabel('x(n)');
subplot(3,2,3); stem(m,real(xe),'ko'); title('Real Even Part')
xlabel('n'); ylabel('xe(n)');
subplot(3,2,5); stem(m,real(xo),'ko'); title('Real Odd Part')
xlabel('n'); ylabel('xo(n)');
subplot(3,2,2); stem(n,imag(x),'ko'); title('Imaginary Original Sequence')
xlabel('n'); ylabel('x(n)');
subplot(3,2,4); stem(m,imag(xe),'ko'); title('Imaginary Even Part')
xlabel('n'); ylabel('xe(n)');
subplot(3,2,6); stem(m,imag(xo),'ko'); title('Imaginary Odd Part')
xlabel('n'); ylabel('xo(n)');