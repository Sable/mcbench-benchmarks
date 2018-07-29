% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 
% 

% solution of the difference equation
% y[n]-1.1y[n-1]+0.5y[n-2]+0.3y[n-4]=0.5x[n]-0.2x[n-1]

 n=0:10;
 a=[1 -1.1 0.5 0 0.3];
 b=[0.5 -0.2];
 x=(n==0);
 h=filter(b,a,x);
 stem(n,h)
 xlim([-.5 10.5]);
 legend('h[n]')

 
 figure
 x= [5 1 1 1 0 0 1 1 1 0 0];
 y1=conv(x,h);
 stem(0:20,y1);
 xlim([-.5 20.5]);
legend('y[n] from conv')



 figure
 a=[1 -1.1 0.5 0 0.3];
 b=[0.5 -0.2];
 x=[5 1 1 1 0 0 1 1 1 0 0];
 x(21)=0;
 y2=filter(b,a,x);
 stem(0:20,y2);
 xlim([-.5 20.5]);
legend('y[n] from filter');
