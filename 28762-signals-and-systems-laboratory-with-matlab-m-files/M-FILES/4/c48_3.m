% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 
% 
% solution of the difference equation
% y[n]=3x[n]-2x[n-1]+4x[n-2]

%impulse response 
 a=1;
 b=[3 -2 4];
 n=0:10;
 x=[1 zeros(1,10)];
 h=filter(b,a,x);
 stem(n,h);

%response to x[n]=[1,-1,3],n=0,1,2
figure
x=[1 -1 3 zeros(1,8)];
y=conv(x,h);
stem(0:20,y);
axis([-1 20 -11 16]);
legend('y[n] with use of conv')


figure
x=[1,-1,3,zeros(1,18)];
y=filter(b,a,x);
stem(0:20,y);
axis([-1 20 -11 16]);
legend('y[n] with use of filter')


