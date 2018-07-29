% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 

% problem 9 - solution of difference equation 

a=[1 1 0.5];
b=[.2 .1 .1];
d=[1 zeros(1,20)];
h=filter(b,a,d);
stem(0:20,h);
title('Impulse response h[n]')
xlim([-1 21])


figure
a=[1 1 0.5];
b=[.2 .1 .1];
u=ones(1,21);
s=filter(b,a,u);
stem(0:20,s);
title('Step response')
xlim([-1 21])



figure
a=[1 1 0.5];
b=[.2 .1 .1];
nx1=0:5;
x1=nx1.*(0.9.^nx1)
nx2=6:20;
x2=zeros(size(nx2))
x=[x1 x2];
y=filter(b,a,x);
stem(0:20,y);
title('Response of the system to x[n]=n*0.9^n ')
xlim([-1 21])
