% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 
% 
% solution of the difference equation
% y[n]=0.5y[n-1]-0.1y[n-2]+0.1x[n]-0.5x[n-1]+x[n-2]


%response to x[n]=[1,2,-1],n=0,1,2
 N=10;
 a=[1 -0.5 0.1];
 b=[0.1 -0.5 1];
 x=[1 2 -1 zeros(1,7)];
 y=filter(b,a,x);
 stem(0:N-1,y);
 legend('y[n]');

 
%impulse response
figure
N=10;
a=[1 -0.5 0.1];
b=[0.1 -0.5 1];
d=[1 zeros(1,N-1)];
h=filter(b,a,d);
stem(0:N-1,h);
xlim([-.5 10]);
legend('h[n]');

% second way
figure
N=10;
x=zeros(N,1); x(1)=1; 
h(1)=0.1; h(2)=-0.45;
for m=3:N
h(m)=0.5*h(m-1)-0.1*h(m-2) +0.1*x(m)-0.5*x(m-1)+x(m-2);
end
stem(0:N-1,h);
xlim([-.3 9.3]);
legend('h[n]');



