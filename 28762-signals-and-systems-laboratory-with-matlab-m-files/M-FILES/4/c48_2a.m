% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 
% 
% solution of the difference equation
% y[n]-1.1y[n-1]+0.9y[n-2]=x[n]


%response to x[n]=[1,2,-1],n=0,1,2
a=[1 -1.1 0.9]; 
 b=1;
 n=0:100;
 x1=[1 2 -1];
 n2=3:100;
 x2=zeros(size(n2));
 x=[x1 x2];
 y=filter(b,a,x);
 stem(n,y);
 axis([ -2 102 -3 3.5]);
 legend('y[n]');

 %impulse response
 a=[1 -1.1 0.9]; 
 b=1;
 n=0:100;
 x=[1,zeros(1,100)]
 h=filter(b,a,x);
 stem(n,h);
 axis([ -2 102 -1 1.2]);
 legend('h[n]');

