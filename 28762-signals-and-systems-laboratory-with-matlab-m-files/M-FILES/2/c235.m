% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
%
% sinusoidal sequence  

 n=0:20;
 x=2*cos(1/2*n+pi/4);
 stem(n,x)
 legend('x[n]')
 grid

 figure
 y=2*cos(pi/6*n+pi/4);
 stem(n,y)
 legend('y[n]')
 grid

 
 
%sampling
figure
t=0:0.01:10;
x=cos(7*t);

Ts1=pi/7;
ts1=0:Ts1:10;
xs1=cos(7*ts1);

Ts2=pi/4;
ts2=0:Ts2:10;
xs2=cos(7*ts2);

plot(t,x,ts1,xs1,':o',ts2, xs2,':+')
legend('x(t)','x[n],T_s=\pi/7','x[n],T_s=\pi/4')


