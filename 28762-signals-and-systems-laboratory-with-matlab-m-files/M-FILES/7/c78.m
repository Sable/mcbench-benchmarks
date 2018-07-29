% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


% circular convolution 



% mod(-m,N)
N=4;
for m=0:3
p(m+1)=mod(-m,N);
end
p




% circular time-reversed sequence
h=[1,1,0.5,2];
for m=0:3
hs(1+m)=h(1+p(m+1));
end
hs'
stem(0:N-1,hs);
axis([-.4 3.4 -.2 2.2])
legend('h_s(m)=h[((-m))_N]')



% circular convolution
clear y;
figure
N=4;
x=[1,0,2.5,1.5];
m=0:N-1;
stem(m,x);
axis([-.4 3.4 -.2 2.9])
legend('x[m]')
n=0;
hsn=circshift(hs',n);
stem(m,hsn);
axis([-.4 3.4 -.2 2.2]);
legend('h[((n-m))_N],n=0')
y(n+1)=sum( x.*hsn')
% or  alternatively  
% y(n+1)=x*hsn;

figure
m=0:N-1;
stem(m,x);
axis([-.4 3.4 -.2 2.9])
legend('x[m]')

figure
n=1;
hsn=circshift(hs',n);
stem(m,hsn);
axis([-.4 3.4 -.2 2.2]);
legend(' h[((n-m))_N], n=1')
y(n+1)=sum(x.*hsn')

figure
n=2;
hsn=circshift(hs',n);
stem(m,hsn);
axis([-.4 3.4 -.2 2.2]);
legend(' h[((n-m))_N], n=2')
y(n+1)=sum(x.*hsn')

figure
n=3;
hsn=circshift(hs',n);
stem(m,hsn);
axis([-.4 3.4 -.2 2.2]);
legend('h[((n-m))_N], n=3')
y(n+1)=x*hsn

figure
stem(m,y)
axis([-.4 3.4 -.2 7.2]);
title('circular convolution')
legend(' y[n] ')

