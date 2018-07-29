% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
%
% 	System response 


% H(z)=(0.1z-0.1)/(z^2-1.5z+0.7)


clear;


%impulse response
num=[.1 .1];
den=[1 -1.5 0.7];

n=0:50;
x=[1 zeros(1,50)];

y=dlsim(num,den,x);

stairs(n,y)
legend('y[n]=h[n]');




% response to (-1).^n, n=0,1,...,50
figure

num=[0.1 0.1];
den=[1 -1.5 0.7];

n=0:50;
x=(-1).^n;

y=dlsim(num,den,x);

stairs(n,y);
legend ('Output signal y[n]')


% second way
figure

y2=filter(num,den,x);
stairs(n,y2); 
legend ('Output signal y[n] ')



