% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 
% Discrete time convolution

%  x=[1,2,3,4,5],0<=n<=4
%  h=[1,2,1],-1<=n<=1



%1st approach  
 n=-1:4;
 x=[0,1,2,3,4,5];
 h=[1,2,1,0,0,0];
 subplot(121);
 stem(n,x);
 axis([-1.1 4.1 -.1 5.1]);
 legend('x[n]')
 subplot(122);
 stem(n,h);
 axis([-1.1 4.1 -.1 5.1]);
 legend('h[n]')

 figure
 y=conv(x,h);
 stem(-2:8,y)
 axis([-2.5 8.5 -.5 16.5]);
 legend('y[n]')
 
 
 %2nd approach  
 figure
 x=[1,2,3,4,5];
 h=[1,2,1];
 y=conv(x,h);
 stem(-1:5,y)
 axis([-2.5 8.5 -.5 16.5]);
 legend('y[n]')

