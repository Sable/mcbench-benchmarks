% P2.6a
%colordef white             % Default Color Scheme
n = -50:50;
x = sin(0.125*pi*n);
subplot(2,2,1); plot(n,x,'ko-'); title('Original Signal sin(0.125\pin)');
[y,m] = dnsample(x,n,4);
subplot(2,2,3); plot(m,y,'ko-'); title('Down-Sampled Signal by a factor of 4');
axis([m(1),m(end),-1,1]);
% P2.6b
x = sin(0.5*pi*n);
subplot(2,2,2); plot(n,x,'ko-'); title('Original Signal sin(0.5\pin)');
[y,m] = dnsample(x,n,4);
subplot(2,2,4); plot(m,y,'ko-'); title('Down-Sampled Signal by a factor of 4');
axis([m(1),m(end),-1,1]);