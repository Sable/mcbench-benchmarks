% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 

% impulse response of a discrete time system 
 

%h[n]=S{delta[n]}
 x=[1 0 0 0];
 n=0:3;
 stem(n,x)
 axis([-.2 3.2 -.1 1.1])
 legend('x[n]=\delta[n]')
 
 figure
 h=[ 2 4 3 1];
 n=0:3;
 stem(n,h)
 axis([-.2 3.2 -.1 4.1])
 legend('h[n]')
 
 figure
 y=conv(x,h);
 stem(0:6,y)
 axis([-.2 6.2 -.1 4.1])
 legend('y[n]=h[n]')

 
 
 
%h[n-n0]=S{delta[n-n0]}
figure
n=0:3;
x=[0 1 0 0];
stem(n,x);
axis([-.1 3.1 -.1 1.1])
legend('x[n]=\delta[n-1]')

figure
h=[ 2 4 3 1];
n=0:3;
stem(n,h)
axis([-.2 6.2 -.1 4.1])
legend('h[n]')

figure
y=conv(x,h);
stem(0:6,y)
axis([-.2 6.2 -.1 4.1])
legend('y[n]=h[n-1]')
