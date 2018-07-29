clear;  clc;
% P2.8
n = 0:200;
x = cos(0.2*pi*n) + 0.5*cos(0.6*pi*n);
a = 0.1;
k = 50;
[y,ny] = sigshift(x,n,k);
y = a*y;
[y,ny] = sigadd(y,ny,x,n);
subplot(2,2,1); stem(n,x,'k'); title('Given Sequence');
subplot(2,2,2); stem(ny,y,'k'); title('Delayed Signal');
[yf,nyf] = sigfold(y,ny);                     % Folded signal
[ry,nry] = conv_m(yf,nyf,y,ny);                 % auto-correlation
subplot(2,2,3); stem(nry,ry,'k'); title('Autocorrelation ryy');
[xf,nf] = sigfold(x,n);                     % Folded signal
[rx,nrx] = conv_m(xf,nf,x,n);                 % auto-correlation
subplot(2,2,4); stem(nrx,rx,'k'); title('Autocorrelation rxx');