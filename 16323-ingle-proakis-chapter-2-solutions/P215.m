clear; clc;
%P2.15
colordef white
b=[1]; a=[1,-0.8];
n=[0:50];x=0.8.^n.*(stepseq(0,0,50));
y=filter(b,a,x);
subplot(2,1,1);stem(n,y,'k');title('Convolution x(n)*x(n) using filter')
[y,m]=conv_m(x,n,x,n);
subplot(2,1,2);stem(m,y,'k');title('Convolution x(n)*x(n) using conv_m')