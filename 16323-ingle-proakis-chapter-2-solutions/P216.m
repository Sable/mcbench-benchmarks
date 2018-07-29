clear;  clc;
%P2.16
%y(n)-0.5y(n-1)+0.25y(n-2)=x(n)+2x(n-x)+x(n-3)
a=[1,-0.5,0.25];b=[1,2,1];
h=impseq(0,-10,100);n=[-10:100];
y=filter(b,a,h);
subplot(2,1,1);
stem(n,y,'k');title('Impulse Response');xlabel('n');ylabel('h(n)')
%We determine S|h(n)|
sum(abs(y))
magz = abs(roots(a))
%ans = 6.5714
%Which implies that the system is stable.

%If x(n)=[5+cos(0.2pn)+4sin(0.6pn)]u(n),
%the impulse response will show no stability
a=[1,-0.5,0.25];b=[1,2,1];
n=[-10:200];
x=(5+3*cos(0.2*pi*n)+4*sin(0.6*pi*n)).*stepseq(0 ,-10,200);
y=filter(b,a,x);
subplot(2,1,2);
stem(n,y,'k');title('Response to x(n)');xlabel('n');ylabel('y(n)')
sum(abs(y))
magz = abs(roots(a))
%ans =  5.3389e+003
% We observe that the response is not bounded, since the output is not close to zero as n approaches infinity.